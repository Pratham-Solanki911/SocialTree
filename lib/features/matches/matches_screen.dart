import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';

/// Pending duplicate suggestions across families. Admins merge, anyone with
/// edit rights can dismiss.
class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final matches = ref.watch(pendingMatchesProvider);
    final me = ref.watch(myPersonProvider).value;
    final isAdmin = ref.watch(myProfileProvider).value?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.matches),
        actions: [
          if (me != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l.findMatches,
              onPressed: () async {
                try {
                  final n = await ref.read(reposProvider).refreshMatches(me.id);
                  ref.invalidate(pendingMatchesProvider);
                  if (context.mounted) showMessage(context, l.matchesRefreshed(n));
                } catch (e) {
                  if (context.mounted) showError(context, e);
                }
              },
            ),
        ],
      ),
      body: AsyncBody<List<MatchSuggestion>>(
        value: matches,
        onRetry: () => ref.invalidate(pendingMatchesProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(text: l.noMatches, icon: Icons.join_full_outlined)
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => _MatchCard(m: list[i], isAdmin: isAdmin),
              ),
      ),
    );
  }
}

class _MatchCard extends ConsumerWidget {
  const _MatchCard({required this.m, required this.isAdmin});
  final MatchSuggestion m;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final a = ref.watch(personProvider(m.personId)).value;
    final b = ref.watch(personProvider(m.candidateId)).value;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Text('${m.score}')),
            title: Text(l.possibleDuplicate),
            subtitle: Text([l.matchScore(m.score), ...m.reasons].join(' · ')),
          ),
          if (a != null) PersonTile(person: a),
          if (b != null) PersonTile(person: b),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  try {
                    await ref.read(reposProvider).dismissMatch(m.id);
                    ref.invalidate(pendingMatchesProvider);
                  } catch (e) {
                    if (context.mounted) showError(context, e);
                  }
                },
                child: Text(l.dismiss),
              ),
              if (isAdmin && a != null && b != null)
                FilledButton.tonal(
                  onPressed: () async {
                    final keep = await showDialog<String>(
                      context: context,
                      builder: (ctx) => SimpleDialog(
                        title: Text(l.keepWhich),
                        children: [
                          SimpleDialogOption(onPressed: () => Navigator.pop(ctx, a.id), child: Text(a.fullName)),
                          SimpleDialogOption(onPressed: () => Navigator.pop(ctx, b.id), child: Text(b.fullName)),
                        ],
                      ),
                    );
                    if (keep == null) return;
                    try {
                      await ref.read(reposProvider).mergePersons(keep, keep == a.id ? b.id : a.id);
                      ref.invalidate(pendingMatchesProvider);
                      ref.invalidate(familyMembersProvider(a.familyId));
                      ref.invalidate(familyMembersProvider(b.familyId));
                    } catch (e) {
                      if (context.mounted) showError(context, e);
                    }
                  },
                  child: Text(l.mergeInto),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
