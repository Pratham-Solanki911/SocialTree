import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../map/latlng_picker.dart';
import '../person/person_detail_screen.dart';

class LifeEventFormScreen extends ConsumerStatefulWidget {
  const LifeEventFormScreen({super.key, required this.personId});
  final String personId;

  @override
  ConsumerState<LifeEventFormScreen> createState() => _LifeEventFormScreenState();
}

class _LifeEventFormScreenState extends ConsumerState<LifeEventFormScreen> {
  final _key = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _place = TextEditingController();
  String _kind = 'other';
  DateTime? _date;
  bool _approx = false;
  LatLng? _latLng;
  bool _saving = false;

  static const kinds = ['birth', 'education', 'marriage', 'migration', 'career', 'death', 'other'];

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(reposProvider).addEvent({
        'person_id': widget.personId,
        'kind': _kind,
        'title': _title.text.trim(),
        'description': _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        'event_date': dateOnly(_date),
        'date_is_approx': _approx,
        'place': _place.text.trim().isEmpty ? null : _place.text.trim(),
        'lat': _latLng?.latitude,
        'lng': _latLng?.longitude,
      });
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    return Scaffold(
      appBar: AppBar(title: Text(l.addEvent), actions: [TextButton(onPressed: _saving ? null : _save, child: Text(l.save))]),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _kind,
              decoration: InputDecoration(labelText: l.eventKind),
              items: [for (final k in kinds) DropdownMenuItem(value: k, child: Row(children: [Icon(eventIcon(k), size: 18), const SizedBox(width: 8), Text(eventKindLabel(context, k))]))],
              onChanged: (v) => setState(() => _kind = v ?? 'other'),
            ),
            TextFormField(controller: _title, decoration: InputDecoration(labelText: l.eventTitle), validator: (v) => (v ?? '').trim().isEmpty ? l.requiredField : null),
            TextFormField(controller: _desc, decoration: InputDecoration(labelText: l.description), maxLines: 3),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.eventDate),
              subtitle: Text(_date == null ? '—' : df.format(_date!)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterChip(label: Text(l.approximate), selected: _approx, onSelected: (v) => setState(() => _approx = v)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: () async {
                      final d = await showDatePicker(context: context, initialDate: _date ?? DateTime.now(), firstDate: DateTime(1800), lastDate: DateTime.now());
                      if (d != null) setState(() => _date = d);
                    },
                  ),
                ],
              ),
            ),
            PlaceField(label: l.place, controller: _place, latLng: _latLng, onLatLng: (v) => _latLng = v),
            const SizedBox(height: 24),
            FilledButton(onPressed: _saving ? null : _save, child: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
