import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final convs = ref.watch(conversationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.chat)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newChat(context, ref),
        icon: const Icon(Icons.add_comment_outlined),
        label: Text(l.newChat),
      ),
      body: AsyncBody<List<ConversationSummary>>(
        value: convs,
        onRetry: () => ref.invalidate(conversationsProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(text: l.noConversations, icon: Icons.chat_bubble_outline)
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(conversationsProvider),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final c = list[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text(c.otherName.isEmpty ? '?' : c.otherName[0].toUpperCase())),
                      title: Text(c.otherName),
                      subtitle: c.lastMessage == null ? null : Text(c.lastMessage!, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => context.push('/chat/${c.id}'),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Future<void> _newChat(BuildContext context, WidgetRef ref) async {
    final other = await pickMember(context, ref);
    if (other == null || !context.mounted) return;
    try {
      final id = await ref.read(reposProvider).openDirectChat(other.id);
      ref.invalidate(conversationsProvider);
      if (context.mounted) context.push('/chat/$id');
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }
}

/// Picks an approved member other than me.
Future<Profile?> pickMember(BuildContext context, WidgetRef ref) async {
  final l = context.l;
  final uid = ref.read(currentUserIdProvider);
  final members = (await ref.read(reposProvider).approvedProfiles()).where((p) => p.id != uid).toList();
  if (!context.mounted) return null;
  return showDialog<Profile>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text(l.chooseMember),
      children: [
        if (members.isEmpty) Padding(padding: const EdgeInsets.all(16), child: Text(l.noResults)),
        for (final m in members) SimpleDialogOption(onPressed: () => Navigator.pop(ctx, m), child: Text(m.displayName)),
      ],
    ),
  );
}
