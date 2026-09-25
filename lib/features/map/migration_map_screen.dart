import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import 'map_tiles.dart';

/// Draws each person's movement (birth place -> migrations -> current place)
/// over an Indian government base map.
class MigrationMapScreen extends ConsumerStatefulWidget {
  const MigrationMapScreen({super.key});

  @override
  ConsumerState<MigrationMapScreen> createState() => _MigrationMapScreenState();
}

class _MigrationMapScreenState extends ConsumerState<MigrationMapScreen> {
  String? _familyId;
  int _tileErrors = 0;
  MapSource? _erroredSource;

  static const _palette = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.brown, Colors.indigo];

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final source = ref.watch(mapSourceProvider);
    final families = ref.watch(familiesProvider).value ?? const <Family>[];
    final hops = ref.watch(migrationPathsProvider(_familyId));
    if (_erroredSource != source) {
      _tileErrors = 0;
      _erroredSource = source;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.migrationMap),
        actions: [
          PopupMenuButton<String?>(
            tooltip: l.family,
            icon: const Icon(Icons.filter_alt_outlined),
            onSelected: (v) => setState(() => _familyId = v == '' ? null : v),
            itemBuilder: (_) => [
              PopupMenuItem<String?>(value: '', child: Text(l.allFamilies)),
              for (final f in families) PopupMenuItem<String?>(value: f.id, child: Text(f.name)),
            ],
          ),
          const MapSourceSelector(),
        ],
      ),
      body: Column(
        children: [
          if (_tileErrors > 6)
            MaterialBanner(
              content: Text(l.mapTilesFailed),
              actions: [TextButton(onPressed: () => ref.read(mapSourceProvider.notifier).set(MapSource.osm), child: Text(l.mapOsm))],
            ),
          Expanded(
            child: hops.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(migrationPathsProvider(_familyId))),
              data: (list) {
                final byPerson = <String, List<MigrationHop>>{};
                for (final h in list) {
                  byPerson.putIfAbsent(h.personId, () => []).add(h);
                }
                final polylines = <Polyline>[];
                final markers = <Marker>[];
                var i = 0;
                for (final entry in byPerson.entries) {
                  final color = _palette[i++ % _palette.length];
                  final pts = entry.value.map((h) => LatLng(h.lat, h.lng)).toList();
                  if (pts.length > 1) polylines.add(Polyline(points: pts, color: color.withValues(alpha: 0.8), strokeWidth: 3));
                  for (final h in entry.value) {
                    markers.add(Marker(
                      point: LatLng(h.lat, h.lng),
                      width: 28,
                      height: 28,
                      child: Tooltip(
                        message: '${h.fullName}\n${h.place ?? ''}${h.onDate != null ? ' (${h.onDate!.year})' : ''}',
                        child: GestureDetector(
                          onTap: () => context.push('/persons/${h.personId}'),
                          child: Icon(h.seq == 1 ? Icons.circle : Icons.place, color: color, size: h.seq == 1 ? 14 : 26),
                        ),
                      ),
                    ));
                  }
                }
                return Stack(
                  children: [
                    FlutterMap(
                      options: const MapOptions(initialCenter: indiaCenter, initialZoom: indiaZoom),
                      children: [
                        tileLayerFor(source, onError: () {
                          if (_tileErrors <= 6 && mounted) setState(() => _tileErrors++);
                        }),
                        PolylineLayer(polylines: polylines),
                        MarkerLayer(markers: markers),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            color: Colors.white70,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Text(l.mapAttribution, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                          ),
                        ),
                      ],
                    ),
                    if (list.isEmpty)
                      Positioned(
                        left: 16,
                        right: 16,
                        top: 16,
                        child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(l.noPaths))),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
