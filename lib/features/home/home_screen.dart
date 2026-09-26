import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/branding.dart';
import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // One salutation per visit to the Home tab; it changes on the next launch.
  late final int _greetingIndex = DateTime.now().microsecond % 4;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final feed = ref.watch(feedProvider);
    final me = ref.watch(myPersonProvider).value;
    final profile = ref.watch(myProfileProvider).value;
    final unread = ref.watch(unreadCountProvider);

    final actions = <(IconData, String, VoidCallback)>[
      if (me == null)
        (Icons.person_search_outlined, l.findMyselfAgain, () => context.push('/find-me'))
      else
        (Icons.account_box_outlined, l.myProfile, () => context.push('/persons/${me.id}')),
      if (me != null) (Icons.account_tree_outlined, l.viewTree, () => context.push('/persons/${me.id}/tree')),
      (Icons.join_full_outlined, l.matches, () => context.push('/matches')),
      (Icons.temple_hindu_outlined, l.gotraLookup, () => context.push('/gotra')),
      (Icons.photo_library_outlined, l.albums, () => context.push('/albums')),
      (Icons.chat_bubble_outline, l.chat, () => context.push('/chat')),
      (Icons.support_agent_outlined, l.support, () => context.push('/support')),
      if (profile?.isAdmin ?? false) (Icons.admin_panel_settings_outlined, l.admin, () => context.push('/admin')),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(padding: EdgeInsets.all(8), child: LogoMark(size: 40)),
        title: Text(greetings(context)[_greetingIndex], style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Badge(isLabelVisible: unread > 0, label: Text('$unread'), child: const Icon(Icons.notifications_outlined)),
            tooltip: l.notifications,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedProvider);
          ref.invalidate(myPersonProvider);
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                decoration: InputDecoration(labelText: l.searchByName, prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder()),
                textInputAction: TextInputAction.search,
                onSubmitted: (q) => context.go('/search?q=${Uri.encodeQueryComponent(q.trim())}'),
              ),
            ),
            SectionTitle(l.quickActions),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: actions.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final (icon, label, onTap) = actions[i];
                  return SizedBox(
                    width: 104,
                    child: Card(
                      child: InkWell(
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon),
                              const SizedBox(height: 6),
                              Text(label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SectionTitle(l.homeFeed),
            AsyncBody<List<FeedItem>>(
              value: feed,
              onRetry: () => ref.invalidate(feedProvider),
              builder: (items) => items.isEmpty
                  ? EmptyState(text: l.noUpdates, icon: Icons.campaign_outlined)
                  : Column(children: [for (final f in items) _FeedTile(item: f)]),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedTile extends StatelessWidget {
  const _FeedTile({required this.item});
  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final kind = switch (item.event.kind) {
      'birth' => (Icons.child_care, l.kindBirth),
      'marriage' => (Icons.favorite_outline, l.kindMarriage),
      _ => (Icons.local_florist_outlined, l.kindDeath),
    };
    final date = item.event.eventDate == null
        ? null
        : DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(item.event.eventDate!);
    return ListTile(
      leading: PersonAvatar(path: item.photoPath, initials: item.personName.isEmpty ? '?' : item.personName[0], size: 36),
      title: Text('${kind.$2}: ${item.personName}'),
      subtitle: Text([item.event.title, ?date].join(' · ')),
      trailing: Icon(kind.$1),
      onTap: () => context.push('/persons/${item.personId}'),
    );
  }
}
