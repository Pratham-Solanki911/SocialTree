import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n_ext.dart';
import '../../core/phone.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../media/media_grid.dart';
import 'add_relative_sheet.dart';
import 'person_tile.dart';

class PersonDetailScreen extends ConsumerWidget {
  const PersonDetailScreen({super.key, required this.personId});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final person = ref.watch(personProvider(personId));
    final profile = ref.watch(myProfileProvider).value;
    final uid = ref.watch(currentUserIdProvider);
    final myPerson = ref.watch(myPersonProvider).value;

    return AsyncBody<Person>(
      value: person,
      onRetry: () => ref.invalidate(personProvider(personId)),
      builder: (p) {
        final canEdit = profile?.isAdmin == true || p.createdBy == uid || p.claimedBy == uid;
        final canClaim = p.claimedBy == null && myPerson == null;
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title: Text(p.fullName),
              actions: [
                if (canEdit)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l.edit,
                    onPressed: () async {
                      await context.push('/persons/$personId/edit');
                      ref.invalidate(personProvider(personId));
                    },
                  ),
                PopupMenuButton<String>(
                  onSelected: (v) async {
                    switch (v) {
                      case 'tree':
                        context.push('/persons/$personId/tree');
                      case 'claim':
                        try {
                          await ref.read(reposProvider).claimPerson(personId);
                          ref.invalidate(personProvider(personId));
                          ref.invalidate(myPersonProvider);
                          if (context.mounted) showMessage(context, l.claimed);
                        } catch (e) {
                          if (context.mounted) showError(context, e);
                        }
                      case 'matches':
                        try {
                          final n = await ref.read(reposProvider).refreshMatches(personId);
                          ref.invalidate(pendingMatchesProvider);
                          if (context.mounted) {
                            showMessage(context, l.matchesRefreshed(n));
                            if (n > 0) context.push('/matches');
                          }
                        } catch (e) {
                          if (context.mounted) showError(context, e);
                        }
                      case 'delete':
                        if (await confirm(context, l.confirmDelete)) {
                          try {
                            await ref.read(reposProvider).deletePerson(personId);
                            ref.invalidate(familyMembersProvider(p.familyId));
                            if (context.mounted) context.pop();
                          } catch (e) {
                            if (context.mounted) showError(context, e);
                          }
                        }
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'tree', child: ListTile(leading: const Icon(Icons.account_tree_outlined), title: Text(l.viewTree))),
                    if (canClaim) PopupMenuItem(value: 'claim', child: ListTile(leading: const Icon(Icons.how_to_reg_outlined), title: Text(l.claimProfile))),
                    PopupMenuItem(value: 'matches', child: ListTile(leading: const Icon(Icons.join_full_outlined), title: Text(l.findMatches))),
                    if (profile?.isAdmin == true) PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Icons.delete_outline), title: Text(l.deletePerson))),
                  ],
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [Tab(text: l.about), Tab(text: l.relatives), Tab(text: l.timeline), Tab(text: l.media), Tab(text: l.notes)],
              ),
            ),
            body: Column(
              children: [
                _Header(person: p, uid: uid),
                Expanded(
                  child: TabBarView(
                    children: [
                      _AboutTab(person: p),
                      _RelativesTab(person: p, canEdit: canEdit),
                      _TimelineTab(person: p, canEdit: canEdit),
                      ListView(children: [MediaGrid(personId: p.id, canEdit: canEdit)]),
                      _NotesTab(person: p),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.person, required this.uid});
  final Person person;
  final String? uid;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final p = person;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonAvatar(path: p.passportPhotoPath, initials: p.initials, size: 84),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.fullName, style: Theme.of(context).textTheme.titleLarge),
                if (p.nickname != null) Text('"${p.nickname}"'),
                Text(lifespan(context, p)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (p.claimedBy != null)
                      Chip(
                        avatar: const Icon(Icons.verified_user_outlined, size: 16),
                        label: Text(p.claimedBy == uid ? l.linkedToYou : l.claimedBySomeone),
                        visualDensity: VisualDensity.compact,
                      ),
                    for (final ph in p.phones) ...[
                      if (ph.whatsapp)
                        ActionChip(
                          avatar: const Icon(Icons.chat, size: 16, color: Colors.green),
                          label: Text(ph.number),
                          tooltip: l.openWhatsApp,
                          onPressed: () => launchUrl(whatsappUri(ph.number), mode: LaunchMode.externalApplication),
                        )
                      else
                        ActionChip(
                          avatar: const Icon(Icons.phone_outlined, size: 16),
                          label: Text(ph.number),
                          tooltip: l.call,
                          onPressed: () => launchUrl(telUri(ph.number)),
                        ),
                    ],
                    if (p.email != null)
                      ActionChip(
                        avatar: const Icon(Icons.mail_outline, size: 16),
                        label: Text(p.email!),
                        onPressed: () => launchUrl(Uri.parse('mailto:${p.email}')),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutTab extends ConsumerWidget {
  const _AboutTab({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final p = person;
    final family = ref.watch(familyProvider(p.familyId)).value;
    final gotras = ref.watch(gotrasProvider).value ?? const <Gotra>[];
    final gotra = gotras.where((g) => g.id == (p.gotraId ?? family?.gotraId)).firstOrNull;
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final genderLabel = switch (p.gender) { 'male' => l.male, 'female' => l.female, _ => l.other };
    return ListView(
      children: [
        ListTile(
          dense: true,
          title: Text(l.family, style: Theme.of(context).textTheme.labelMedium),
          subtitle: Text(family?.name ?? '…', style: Theme.of(context).textTheme.bodyLarge),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/families/${p.familyId}'),
        ),
        LabeledValue(l.gender, genderLabel),
        LabeledValue(l.dateOfBirth, p.dob == null ? null : '${p.dobIsApprox ? '~' : ''}${df.format(p.dob!)}'),
        if (!p.isAlive) LabeledValue(l.dateOfDeath, p.dod == null ? l.deceased : df.format(p.dod!)),
        LabeledValue(l.maidenName, p.maidenName),
        LabeledValue(l.gotra, gotra?.name),
        LabeledValue(l.kuldevi, p.kuldevi ?? family?.kuldevi ?? gotra?.kuldevi),
        LabeledValue(l.kuldevta, p.kuldevta ?? family?.kuldevta ?? gotra?.kuldevta),
        LabeledValue(l.nativeVillage, p.nativeVillage),
        LabeledValue(l.birthPlace, p.birthPlace),
        LabeledValue(l.currentPlace, p.currentPlace),
        LabeledValue(l.occupation, p.occupation),
        LabeledValue(l.education, p.education),
        LabeledValue(l.maritalStatus, p.maritalStatus),
        LabeledValue(l.bloodGroup, p.bloodGroup),
      ],
    );
  }
}

class _RelativesTab extends ConsumerWidget {
  const _RelativesTab({required this.person, required this.canEdit});
  final Person person;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final tree = ref.watch(treeProvider((person.id, 1)));
    Future<void> add([String? kind]) async {
      if (await showAddRelativeSheet(context, ref, person, kind: kind)) {
        ref.invalidate(treeProvider((person.id, 1)));
      }
    }

    return AsyncBody<TreeData>(
      value: tree,
      onRetry: () => ref.invalidate(treeProvider((person.id, 1))),
      builder: (t) {
        final groups = <(String, List<Person>, String)>[
          (l.parents, t.parentsOf(person.id), 'parent'),
          (l.spouses, t.spousesOf(person.id), 'spouse'),
          (l.children, t.childrenOf(person.id), 'child'),
          (l.siblings, t.siblingsOf(person.id), ''),
        ];
        return ListView(
          children: [
            for (final (title, people, kind) in groups) ...[
              SectionTitle(
                title,
                trailing: kind.isEmpty ? null : IconButton(icon: const Icon(Icons.add), onPressed: () => add(kind)),
              ),
              if (people.isEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('—', style: Theme.of(context).textTheme.bodySmall)),
              for (final r in people)
                PersonTile(
                  person: r,
                  trailing: canEdit && kind.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.link_off),
                          tooltip: l.removeRelationship,
                          onPressed: () async {
                            final rel = t.relationships.firstWhere((x) =>
                                (x.personId == person.id && x.relatedId == r.id) || (x.personId == r.id && x.relatedId == person.id));
                            if (!await confirm(context, l.confirmDelete)) return;
                            try {
                              await ref.read(reposProvider).removeRelationship(rel.id);
                              ref.invalidate(treeProvider((person.id, 1)));
                            } catch (e) {
                              if (context.mounted) showError(context, e);
                            }
                          },
                        )
                      : null,
                ),
            ],
            const SizedBox(height: 12),
            Center(child: FilledButton.tonalIcon(onPressed: () => add(), icon: const Icon(Icons.person_add_alt_1_outlined), label: Text(l.addRelative))),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

IconData eventIcon(String kind) => switch (kind) {
      'birth' => Icons.child_care,
      'education' => Icons.school_outlined,
      'marriage' => Icons.favorite_outline,
      'migration' => Icons.flight_takeoff,
      'career' => Icons.work_outline,
      'death' => Icons.local_florist_outlined,
      _ => Icons.event_note_outlined,
    };

String eventKindLabel(BuildContext context, String kind) {
  final l = context.l;
  return switch (kind) {
    'birth' => l.kindBirth,
    'education' => l.kindEducation,
    'marriage' => l.kindMarriage,
    'migration' => l.kindMigration,
    'career' => l.kindCareer,
    'death' => l.kindDeath,
    _ => l.kindOther,
  };
}

class _TimelineTab extends ConsumerWidget {
  const _TimelineTab({required this.person, required this.canEdit});
  final Person person;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final events = ref.watch(eventsProvider(person.id));
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    return AsyncBody<List<LifeEvent>>(
      value: events,
      onRetry: () => ref.invalidate(eventsProvider(person.id)),
      builder: (list) => ListView(
        children: [
          if (canEdit)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  await context.push('/persons/${person.id}/events/new');
                  ref.invalidate(eventsProvider(person.id));
                  ref.invalidate(feedProvider);
                },
                icon: const Icon(Icons.add),
                label: Text(l.addEvent),
              ),
            ),
          if (list.isEmpty) EmptyState(text: l.noEvents, icon: Icons.timeline),
          for (final e in list)
            ListTile(
              leading: CircleAvatar(child: Icon(eventIcon(e.kind))),
              title: Text(e.title),
              subtitle: Text([
                eventKindLabel(context, e.kind),
                if (e.eventDate != null) '${e.dateIsApprox ? '~' : ''}${df.format(e.eventDate!)}',
                if (e.place != null) e.place!,
                if (e.description != null) e.description!,
              ].join(' · ')),
              isThreeLine: e.description != null,
              trailing: canEdit
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        if (!await confirm(context, l.confirmDelete)) return;
                        try {
                          await ref.read(reposProvider).deleteEvent(e.id);
                          ref.invalidate(eventsProvider(person.id));
                        } catch (err) {
                          if (context.mounted) showError(context, err);
                        }
                      },
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.biography, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(person.biography ?? '—'),
        const SizedBox(height: 16),
        Text(l.notes, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(person.notes ?? '—'),
      ],
    );
  }
}
