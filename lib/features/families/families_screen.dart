import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../core/names.dart';
import '../../models/models.dart';
import '../person/bilingual_name_fields.dart';

class FamiliesScreen extends ConsumerWidget {
  const FamiliesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final families = ref.watch(familiesProvider);
    final counts = ref.watch(familyMemberCountsProvider).value ?? const {};
    return Scaffold(
      appBar: AppBar(title: Text(l.familiesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showFamilyDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.newFamily),
      ),
      body: AsyncBody<List<Family>>(
        value: families,
        onRetry: () => ref.invalidate(familiesProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(text: l.noFamilies, icon: Icons.groups_outlined)
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(familiesProvider);
                  ref.invalidate(familyMemberCountsProvider);
                },
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final f = list[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text(f.surname.isEmpty ? '?' : f.surname[0])),
                      title: NameText(familyName(context, f)),
                      subtitle: Text([displayName(context, gu: f.surname, en: f.surnameEn).primary, if (f.nativeVillage != null) f.nativeVillage!].join(' · ')),
                      trailing: Text(l.memberCount(counts[f.id] ?? 0)),
                      onTap: () => context.go('/families/${f.id}'),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

/// Create or edit a family. Returns the saved family id.
Future<String?> showFamilyDialog(BuildContext context, WidgetRef ref, {Family? existing}) async {
  final l = context.l;
  final name = TextEditingController(text: existing?.name);
  final nameEn = TextEditingController(text: existing?.nameEn);
  final surname = TextEditingController(text: existing?.surname);
  final surnameEn = TextEditingController(text: existing?.surnameEn);
  final village = TextEditingController(text: existing?.nativeVillage);
  final kuldevi = TextEditingController(text: existing?.kuldevi);
  final kuldevta = TextEditingController(text: existing?.kuldevta);
  final desc = TextEditingController(text: existing?.description);
  String? gotraId = existing?.gotraId;
  final gotras = ref.read(gotrasProvider).value ?? const <Gotra>[];
  final key = GlobalKey<FormState>();

  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(existing == null ? l.newFamily : l.edit),
        content: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BilingualNameFields(gu: name, en: nameEn, labelGu: l.familyNameGu, labelEn: l.familyNameEn, required: true),
                BilingualNameFields(gu: surname, en: surnameEn, labelGu: l.surnameGu, labelEn: l.surnameEn, required: true),
                TextFormField(controller: village, decoration: InputDecoration(labelText: l.nativeVillage)),
                DropdownButtonFormField<String?>(
                  initialValue: gotraId,
                  decoration: InputDecoration(labelText: l.gotra),
                  items: [
                    DropdownMenuItem<String?>(value: null, child: Text(l.none)),
                    for (final g in gotras) DropdownMenuItem<String?>(value: g.id, child: Text(g.name)),
                  ],
                  onChanged: (v) => setState(() => gotraId = v),
                ),
                TextFormField(controller: kuldevi, decoration: InputDecoration(labelText: l.kuldevi)),
                TextFormField(controller: kuldevta, decoration: InputDecoration(labelText: l.kuldevta)),
                TextFormField(controller: desc, decoration: InputDecoration(labelText: l.description), maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              if (key.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
  if (saved != true) return null;
  String? nz(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
  final map = {
    'name': nz(name) ?? nameEn.text.trim(),
    'name_en': nz(nameEn),
    'surname': nz(surname) ?? surnameEn.text.trim(),
    'surname_en': nz(surnameEn),
    'native_village': nz(village),
    'gotra_id': gotraId,
    'kuldevi': nz(kuldevi),
    'kuldevta': nz(kuldevta),
    'description': nz(desc),
  };
  try {
    final repos = ref.read(reposProvider);
    String id;
    if (existing == null) {
      id = (await repos.createFamily(map)).id;
    } else {
      id = existing.id;
      await repos.updateFamily(id, map);
    }
    ref.invalidate(familiesProvider);
    ref.invalidate(familyProvider(id));
    return id;
  } catch (e) {
    if (context.mounted) showError(context, e);
    return null;
  }
}
