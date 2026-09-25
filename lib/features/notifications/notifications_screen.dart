import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final items = ref.watch(notificationsProvider);
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_jm();
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notifications),
        actions: [TextButton(onPressed: () => ref.read(reposProvider).markAllRead(), child: Text(l.markAllRead))],
      ),
      body: AsyncBody<List<AppNotification>>(
        value: items,
        builder: (list) => list.isEmpty
            ? EmptyState(text: l.noNotifications, icon: Icons.notifications_none)
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final n = list[i];
                  final icon = switch (n.kind) {
                    'event' => Icons.campaign_outlined,
                    'chat' => Icons.chat_bubble_outline,
                    'match' => Icons.join_full_outlined,
                    'support' => Icons.support_agent_outlined,
                    'membership' => Icons.how_to_reg_outlined,
                    'claim' => Icons.verified_user_outlined,
                    _ => Icons.notifications_outlined,
                  };
                  return ListTile(
                    leading: Icon(icon, color: n.isRead ? null : Theme.of(context).colorScheme.primary),
                    title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                    subtitle: Text([if (n.body != null) n.body!, df.format(n.createdAt.toLocal())].join('\n')),
                    isThreeLine: n.body != null,
                    onTap: () {
                      if (!n.isRead) ref.read(reposProvider).markRead(n.id);
                      final d = n.data;
                      if (d['claim_id'] != null) {
                        context.push('/claims');
                      } else if (d['person_id'] != null) {
                        context.push('/persons/${d['person_id']}');
                      } else if (d['conversation_id'] != null) {
                        context.push('/chat/${d['conversation_id']}');
                      } else if (d['ticket_id'] != null) {
                        context.push('/support/${d['ticket_id']}');
                      } else if (d['suggestion_id'] != null) {
                        context.push('/matches');
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
