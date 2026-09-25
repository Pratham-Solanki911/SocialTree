import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n_ext.dart';

/// Government of India base maps first, OpenStreetMap as the fallback.
/// Endpoints are public services; verify layer names against each service's
/// capabilities document if a source stops rendering.
enum MapSource { bharatmaps, bhuvan, osm }

class MapSourceNotifier extends Notifier<MapSource> {
  @override
  MapSource build() => MapSource.bharatmaps;
  void set(MapSource s) => state = s;
}

final mapSourceProvider = NotifierProvider<MapSourceNotifier, MapSource>(MapSourceNotifier.new);

const indiaCenter = LatLng(22.5, 79.0);
const indiaZoom = 4.4;
const _ua = 'in.samaj.socialtree';

String mapSourceLabel(BuildContext context, MapSource s) => switch (s) {
      MapSource.bharatmaps => context.l.mapBharatmaps,
      MapSource.bhuvan => context.l.mapBhuvan,
      MapSource.osm => context.l.mapOsm,
    };

/// Tile layer for the chosen source. `onError` fires per failed tile so the
/// screen can offer a different source.
Widget tileLayerFor(MapSource s, {void Function()? onError}) {
  void err(TileImage tile, Object error, StackTrace? st) => onError?.call();
  return switch (s) {
    // NIC Bharatmaps: ArcGIS cached map service (Web Mercator, 256px tiles).
    MapSource.bharatmaps => TileLayer(
        urlTemplate: 'https://webgis3.nic.in/bharatmaps/rest/services/BharatMapService/Admin_Boundary_District/MapServer/tile/{z}/{y}/{x}',
        userAgentPackageName: _ua,
        maxNativeZoom: 12,
        errorTileCallback: err,
      ),
    // ISRO Bhuvan: OGC WMS from NRSC.
    MapSource.bhuvan => TileLayer(
        wmsOptions: WMSTileLayerOptions(
          baseUrl: 'https://bhuvan-vec1.nrsc.gov.in/bhuvan/wms?',
          layers: const ['india3'],
          format: 'image/png',
          transparent: true,
        ),
        userAgentPackageName: _ua,
        errorTileCallback: err,
      ),
    MapSource.osm => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: _ua,
        errorTileCallback: err,
      ),
  };
}

/// Dropdown for the AppBar.
class MapSourceSelector extends ConsumerWidget {
  const MapSourceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(mapSourceProvider);
    return PopupMenuButton<MapSource>(
      tooltip: context.l.mapSource,
      icon: const Icon(Icons.layers_outlined),
      initialValue: current,
      onSelected: (s) => ref.read(mapSourceProvider.notifier).set(s),
      itemBuilder: (_) => [for (final s in MapSource.values) PopupMenuItem(value: s, child: Text(mapSourceLabel(context, s)))],
    );
  }
}
