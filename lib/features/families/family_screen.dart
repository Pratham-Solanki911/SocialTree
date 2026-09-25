import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/names.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';
import 'families_screen.dart';

class FamilyScreen extends ConsumerStatefulWidget {
  const FamilyScreen({super.key, required this.familyId});
  final String familyId;

  @override
  ConsumerState<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends ConsumerState<FamilyScreen> {
  String _filter = '';
  String get familyId => widget.familyId;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final family = ref.watch(familyProvider(familyId));
    final members = ref.watch(familyMembersProvider(familyId));
    final gotras = ref.watch(gotrasProvider).value ?? const <Gotra>[];

    return Scaffold(
      appBar: AppBar(
        title: family.value == null ? Text(l.family) : NameText(familyName(context, family.value!), maxLines: 1),
        actions: [
          if (family.value != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l.edit,
              onPressed: () => showFamilyDialog(context, ref, existing: family.value),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push<String>('/persons/new?familyId=$familyId');
          ref.invalidate(familyMembersProvider(familyId));
          ref.invalidate(familyMemberCountsProvider);
        },
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: Text(l.addPerson),
      ),
      body: AsyncBody<Family>(
        value: family,
        onRetry: () => ref.invalidate(familyProvider(familyId)),
        builder: (f) {
          final gotra = gotras.where((g) => g.id == f.gotraId).firstOrNull;
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(familyMembersProvider(familyId)),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NameText(familyName(context, f), style: Theme.of(context).textTheme.headlineSmall),
                      Text([displayName(context, gu: f.surname, en: f.surnameEn).primary, if (f.nativeVillage != null) f.nativeVillage!].join(' · ')),
                      if (f.description != null) ...[const SizedBox(height: 8), Text(f.description!)],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (gotra != null) Chip(avatar: const Icon(Icons.temple_hindu_outlined, size: 18), label: Text('${l.gotra}: ${gotra.name}')),
                          if ((f.kuldevi ?? gotra?.kuldevi) != null) Chip(label: Text('${l.kuldevi}: ${f.kuldevi ?? gotra!.kuldevi}')),
                          if ((f.kuldevta ?? gotra?.kuldevta) != null) Chip(label: Text('${l.kuldevta}: ${f.kuldevta ?? gotra!.kuldevta}')),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: members.value == null || members.value!.isEmpty
                            ? null
                            : () {
                                // Root the tree at the oldest member so the whole family is reachable.
                                final sorted = [...members.value!]..sort((a, b) => (a.dob ?? DateTime(2100)).compareTo(b.dob ?? DateTime(2100)));
                                context.push('/persons/${sorted.first.id}/tree');
                              },
                        icon: const Icon(Icons.account_tree_outlined),
                        label: Text(l.familyTree),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.push('/albums'),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(l.familyAlbum),
                      ),
                    ],
                  ),
                ),
                SectionTitle(l.members, trailing: Text(l.memberCount(members.value?.length ?? 0))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(labelText: l.filterMembers, prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder()),
                    onChanged: (v) => setState(() => _filter = v.trim().toLowerCase()),
                  ),
                ),
                AsyncBody<List<Person>>(
                  value: members,
                  onRetry: () => ref.invalidate(familyMembersProvider(familyId)),
                  builder: (list) {
                    final shown = _filter.isEmpty
                        ? list
                        : list.where((p) => '${p.fullName} ${p.fullNameEn ?? ''} ${p.nickname ?? ''}'.toLowerCase().contains(_filter)).toList();
                    return shown.isEmpty
                        ? EmptyState(text: _filter.isEmpty ? l.noRelatives : l.noResults, icon: Icons.person_outline)
                        : Column(children: [for (final p in shown) PersonTile(person: p)]);
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}
