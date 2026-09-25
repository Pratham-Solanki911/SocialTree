import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n_ext.dart';
import 'map_tiles.dart';

/// Place name + optional coordinates chosen by tapping a map. No geocoding
/// API is used, so this stays free-tier friendly.
class PlaceField extends StatefulWidget {
  const PlaceField({super.key, required this.label, required this.controller, required this.latLng, required this.onLatLng});
  final String label;
  final TextEditingController controller;
  final LatLng? latLng;
  final ValueChanged<LatLng?> onLatLng;

  @override
  State<PlaceField> createState() => _PlaceFieldState();
}

class _PlaceFieldState extends State<PlaceField> {
  late LatLng? _value = widget.latLng;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              helperText: _value == null ? null : '${l.locationSet}: ${_value!.latitude.toStringAsFixed(3)}, ${_value!.longitude.toStringAsFixed(3)}',
            ),
          ),
        ),
        IconButton(
          tooltip: l.pickOnMap,
          icon: Icon(_value == null ? Icons.add_location_alt_outlined : Icons.edit_location_alt, color: _value == null ? null : Theme.of(context).colorScheme.primary),
          onPressed: () async {
            final picked = await showDialog<LatLng?>(
              context: context,
              builder: (_) => _PickerDialog(initial: _value),
            );
            if (picked == null) return;
            setState(() => _value = picked.latitude.isNaN ? null : picked);
            widget.onLatLng(_value);
          },
        ),
      ],
    );
  }
}

class _PickerDialog extends ConsumerStatefulWidget {
  const _PickerDialog({this.initial});
  final LatLng? initial;

  @override
  ConsumerState<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends ConsumerState<_PickerDialog> {
  late LatLng? _pos = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final source = ref.watch(mapSourceProvider);
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.tapToPick),
          actions: [
            const MapSourceSelector(),
            if (_pos != null)
              // NaN latitude signals "cleared" back to the field.
              TextButton(onPressed: () => Navigator.pop(context, const LatLng(double.nan, 0)), child: Text(l.clearLocation)),
            FilledButton(onPressed: _pos == null ? null : () => Navigator.pop(context, _pos), child: Text(l.done)),
            const SizedBox(width: 8),
          ],
        ),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: _pos ?? indiaCenter,
            initialZoom: _pos == null ? indiaZoom : 9,
            onTap: (_, p) => setState(() => _pos = p),
          ),
          children: [
            tileLayerFor(source),
            if (_pos != null)
              MarkerLayer(markers: [
                Marker(point: _pos!, width: 40, height: 40, alignment: Alignment.topCenter, child: const Icon(Icons.location_on, size: 40, color: Colors.red)),
              ]),
          ],
        ),
      ),
    );
  }
}
