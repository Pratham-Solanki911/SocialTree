import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../core/names.dart';
import '../../models/models.dart';
import '../person/person_detail_screen.dart' show eventKindLabel;
import '../support/support_screen.dart' show ticketStatusLabel;

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
                  final (title, body) = _localised(context, n);
                  return ListTile(
                    leading: Icon(icon, color: n.isRead ? null : Theme.of(context).colorScheme.primary),
                    title: Text(title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                    subtitle: Text([?body, df.format(n.createdAt.toLocal())].join('\n')),
                    isThreeLine: body != null,
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

/// Builds the message from `data` so it reads in the user's language; falls
/// back to the stored English text for older rows.
(String, String?) _localised(BuildContext context, AppNotification n) {
  final l = context.l;
  final d = n.data;
  String person() => displayName(context, gu: d['person_name'] as String?, en: d['person_name_en'] as String?).primary;
  switch (n.kind) {
    case 'event':
      if (d['event_kind'] != null) return ('${eventKindLabel(context, d['event_kind'] as String)}: ${person()}', d['event_title'] as String?);
    case 'membership':
      if (d['subkind'] == 'new_member') return (l.notifNewMember(d['member_name'] as String? ?? '?'), null);
      if (d['subkind'] == 'approved') return (l.notifWelcome, null);
    case 'claim':
      switch (d['subkind']) {
        case 'request':
          return (l.notifClaimRequest(d['requester_name'] as String? ?? '?'), person());
        case 'approved':
          return (l.notifClaimApproved(person()), null);
        case 'rejected':
          return (l.notifClaimRejected(person()), d['reason'] as String?);
      }
    case 'chat':
      if (d['sender_name'] != null) return (l.notifChat(d['sender_name'] as String), d['preview'] as String?);
    case 'match':
      return (l.notifMatch, null);
    case 'support':
      if (d['subkind'] == 'status') return (l.notifSupportStatus(ticketStatusLabel(context, d['status'] as String? ?? 'open')), d['subject'] as String?);
      if (d['subkind'] == 'reply') return (l.notifSupportReply, d['preview'] as String?);
  }
  return (n.title, n.body);
}
