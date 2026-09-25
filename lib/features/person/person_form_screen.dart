import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../map/latlng_picker.dart';
import 'passport_photo_field.dart';
import 'phones_field.dart';

/// Create (familyId) or edit (personId) a person. Pops with the person id.
class PersonFormScreen extends ConsumerStatefulWidget {
  const PersonFormScreen({super.key, this.personId, this.familyId, this.linkToMe = false});
  final String? personId;
  final String? familyId;
  /// After saving, link the new record to the signed-in member.
  final bool linkToMe;

  @override
  ConsumerState<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends ConsumerState<PersonFormScreen> {
  final _key = GlobalKey<FormState>();
  final _c = <String, TextEditingController>{};
  Person? _existing;
  bool _loaded = false;
  bool _saving = false;

  String? _familyId;
  String _gender = 'male';
  DateTime? _dob;
  bool _dobApprox = false;
  DateTime? _dod;
  bool _alive = true;
  LatLng? _birth;
  LatLng? _current;
  String? _gotraId;
  List<PhoneEntry> _phones = const [];
  Uint8List? _photo;
  bool _photoRemoved = false;

  TextEditingController c(String k) => _c.putIfAbsent(k, () => TextEditingController());

  @override
  void initState() {
    super.initState();
    _familyId = widget.familyId;
    if (widget.personId == null) {
      _loaded = true;
    } else {
      ref.read(reposProvider).person(widget.personId!).then((p) {
        if (!mounted) return;
        setState(() {
          _existing = p;
          _familyId = p.familyId;
          _gender = p.gender;
          _dob = p.dob;
          _dobApprox = p.dobIsApprox;
          _dod = p.dod;
          _alive = p.isAlive;
          _birth = p.birthLat == null ? null : LatLng(p.birthLat!, p.birthLng!);
          _current = p.currentLat == null ? null : LatLng(p.currentLat!, p.currentLng!);
          _gotraId = p.gotraId;
          _phones = p.phones;
          c('first_name').text = p.firstName;
          c('middle_name').text = p.middleName ?? '';
          c('last_name').text = p.lastName;
          c('maiden_name').text = p.maidenName ?? '';
          c('nickname').text = p.nickname ?? '';
          c('birth_place').text = p.birthPlace ?? '';
          c('current_place').text = p.currentPlace ?? '';
          c('native_village').text = p.nativeVillage ?? '';
          c('kuldevi').text = p.kuldevi ?? '';
          c('kuldevta').text = p.kuldevta ?? '';
          c('email').text = p.email ?? '';
          c('occupation').text = p.occupation ?? '';
          c('education').text = p.education ?? '';
          c('marital_status').text = p.maritalStatus ?? '';
          c('blood_group').text = p.bloodGroup ?? '';
          c('biography').text = p.biography ?? '';
          c('notes').text = p.notes ?? '';
          _loaded = true;
        });
      }).catchError((Object e) {
        if (mounted) showError(context, e);
      });
    }
  }

  @override
  void dispose() {
    for (final x in _c.values) {
      x.dispose();
    }
    super.dispose();
  }

  String? _nz(String k) {
    final v = c(k).text.trim();
    return v.isEmpty ? null : v;
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate() || _familyId == null) return;
    setState(() => _saving = true);
    final map = <String, dynamic>{
      'family_id': _familyId,
      'first_name': c('first_name').text.trim(),
      'middle_name': _nz('middle_name'),
      'last_name': c('last_name').text.trim(),
      'maiden_name': _nz('maiden_name'),
      'nickname': _nz('nickname'),
      'gender': _gender,
      'dob': dateOnly(_dob),
      'dob_is_approx': _dobApprox,
      'dod': _alive ? null : dateOnly(_dod),
      'is_alive': _alive,
      'birth_place': _nz('birth_place'),
      'birth_lat': _birth?.latitude,
      'birth_lng': _birth?.longitude,
      'current_place': _nz('current_place'),
      'current_lat': _current?.latitude,
      'current_lng': _current?.longitude,
      'native_village': _nz('native_village'),
      'gotra_id': _gotraId,
      'kuldevi': _nz('kuldevi'),
      'kuldevta': _nz('kuldevta'),
      'phones': _phones.map((p) => p.toMap()).toList(),
      'email': _nz('email'),
      'occupation': _nz('occupation'),
      'education': _nz('education'),
      'marital_status': _nz('marital_status'),
      'blood_group': _nz('blood_group'),
      'biography': _nz('biography'),
      'notes': _nz('notes'),
    };
    final repos = ref.read(reposProvider);
    try {
      String id;
      if (_existing == null) {
        id = (await repos.createPerson(map)).id;
      } else {
        id = _existing!.id;
        await repos.updatePerson(id, map);
      }
      if (widget.linkToMe && _existing == null) {
        await repos.requestClaim(id); // self-created: approved at once
        ref.invalidate(myProfileProvider);
      }
      if (_photo != null) {
        await repos.uploadPassport(id, _photo!);
      } else if (_photoRemoved && _existing?.passportPhotoPath != null) {
        await repos.removePassport(id, _existing!.passportPhotoPath!);
      }
      ref.invalidate(personProvider(id));
      ref.invalidate(familyMembersProvider(_familyId!));
      ref.invalidate(myPersonProvider);
      ref.invalidate(recentPersonsProvider);
      if (mounted) {
        showMessage(context, context.l.saved);
        context.pop(id);
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<DateTime?> _pickDate(DateTime? initial) => showDatePicker(
        context: context,
        initialDate: initial ?? DateTime(1980),
        firstDate: DateTime(1800),
        lastDate: DateTime.now(),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    if (!_loaded) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final families = ref.watch(familiesProvider).value ?? const <Family>[];
    final gotras = ref.watch(gotrasProvider).value ?? const <Gotra>[];
    final family = families.where((f) => f.id == _familyId).firstOrNull;
    final gotra = gotras.where((g) => g.id == _gotraId).firstOrNull;

    Widget text(String key, String label, {int maxLines = 1, bool required = false, TextInputType? type}) => TextFormField(
          controller: c(key),
          decoration: InputDecoration(labelText: label),
          maxLines: maxLines,
          keyboardType: type,
          validator: required ? (v) => (v ?? '').trim().isEmpty ? l.requiredField : null : null,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? l.addPerson : l.edit),
        actions: [
          TextButton(onPressed: _saving ? null : _save, child: Text(l.savePerson)),
        ],
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PassportPhotoField(
              existingPath: _existing?.passportPhotoPath,
              onChanged: ({bytes, removed = false}) {
                _photo = bytes;
                _photoRemoved = removed;
              },
            ),
            const SizedBox(height: 16),
            if (_existing == null)
              DropdownButtonFormField<String>(
                initialValue: _familyId,
                decoration: InputDecoration(labelText: l.family),
                items: [for (final f in families) DropdownMenuItem(value: f.id, child: Text(f.name))],
                onChanged: (v) => setState(() => _familyId = v),
                validator: (v) => v == null ? l.requiredField : null,
              ),
            SectionTitle(l.identity),
            text('first_name', l.firstName, required: true),
            text('middle_name', l.middleName),
            text('last_name', l.lastName, required: true),
            if (_gender == 'female') text('maiden_name', l.maidenName),
            text('nickname', l.nickname),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'male', label: Text(l.male), icon: const Icon(Icons.male)),
                ButtonSegment(value: 'female', label: Text(l.female), icon: const Icon(Icons.female)),
                ButtonSegment(value: 'other', label: Text(l.other)),
              ],
              selected: {_gender},
              onSelectionChanged: (s) => setState(() => _gender = s.first),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.dateOfBirth),
              subtitle: Text(_dob == null ? '—' : df.format(_dob!)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterChip(label: Text(l.approximate), selected: _dobApprox, onSelected: (v) => setState(() => _dobApprox = v)),
                  IconButton(icon: const Icon(Icons.calendar_today_outlined), onPressed: () async {
                    final d = await _pickDate(_dob);
                    if (d != null) setState(() => _dob = d);
                  }),
                ],
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_alive ? l.alive : l.deceased),
              value: !_alive,
              onChanged: (v) => setState(() => _alive = !v),
            ),
            if (!_alive)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.dateOfDeath),
                subtitle: Text(_dod == null ? '—' : df.format(_dod!)),
                trailing: IconButton(icon: const Icon(Icons.calendar_today_outlined), onPressed: () async {
                  final d = await _pickDate(_dod);
                  if (d != null) setState(() => _dod = d);
                }),
              ),
            SectionTitle(l.gotraLookup),
            DropdownButtonFormField<String?>(
              initialValue: _gotraId,
              decoration: InputDecoration(labelText: l.gotra),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text(l.none)),
                for (final g in gotras) DropdownMenuItem<String?>(value: g.id, child: Text(g.name)),
              ],
              onChanged: (v) => setState(() => _gotraId = v),
            ),
            TextFormField(
              controller: c('kuldevi'),
              decoration: InputDecoration(
                labelText: l.kuldevi,
                helperText: family?.kuldevi != null ? l.fromFamily(family!.kuldevi!) : gotra?.kuldevi != null ? l.fromGotra(gotra!.kuldevi!) : null,
              ),
            ),
            TextFormField(
              controller: c('kuldevta'),
              decoration: InputDecoration(
                labelText: l.kuldevta,
                helperText: family?.kuldevta != null ? l.fromFamily(family!.kuldevta!) : gotra?.kuldevta != null ? l.fromGotra(gotra!.kuldevta!) : null,
              ),
            ),
            SectionTitle(l.places),
            text('native_village', l.nativeVillage),
            PlaceField(label: l.birthPlace, controller: c('birth_place'), latLng: _birth, onLatLng: (v) => _birth = v),
            PlaceField(label: l.currentPlace, controller: c('current_place'), latLng: _current, onLatLng: (v) => _current = v),
            SectionTitle(l.contact),
            PhonesField(initial: _phones, onChanged: (v) => _phones = v),
            text('email', l.email, type: TextInputType.emailAddress),
            SectionTitle(l.about),
            text('occupation', l.occupation),
            text('education', l.education),
            text('marital_status', l.maritalStatus),
            text('blood_group', l.bloodGroup),
            text('biography', l.biography, maxLines: 4),
            text('notes', l.notes, maxLines: 4),
            const SizedBox(height: 24),
            FilledButton(onPressed: _saving ? null : _save, child: Text(l.savePerson)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
