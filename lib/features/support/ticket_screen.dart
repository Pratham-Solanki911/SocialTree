import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import 'support_screen.dart';

class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key, required this.ticketId});
  final String ticketId;

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  final _reply = TextEditingController();

  Future<void> _send() async {
    final body = _reply.text.trim();
    if (body.isEmpty) return;
    try {
      await ref.read(reposProvider).replyTicket(widget.ticketId, body);
      _reply.clear();
      ref.invalidate(ticketMessagesProvider(widget.ticketId));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  Future<void> _setStatus(String s) async {
    try {
      await ref.read(reposProvider).setTicketStatus(widget.ticketId, s);
      ref.invalidate(ticketProvider(widget.ticketId));
      ref.invalidate(ticketsProvider);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final ticket = ref.watch(ticketProvider(widget.ticketId));
    final msgs = ref.watch(ticketMessagesProvider(widget.ticketId));
    final uid = ref.watch(currentUserIdProvider);
    final canSupport = ref.watch(myProfileProvider).value?.canSupport ?? false;
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_jm();
    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.value?.subject ?? l.support),
        actions: [
          if (canSupport && ticket.value != null)
            PopupMenuButton<String>(
              initialValue: ticket.value!.status,
              onSelected: _setStatus,
              itemBuilder: (_) => [for (final s in ['open', 'in_progress', 'resolved']) PopupMenuItem(value: s, child: Text(ticketStatusLabel(context, s)))],
            ),
        ],
      ),
      body: AsyncBody<SupportTicket>(
        value: ticket,
        onRetry: () => ref.invalidate(ticketProvider(widget.ticketId)),
        builder: (t) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Card(
                    child: ListTile(
                      title: Text(t.subject),
                      subtitle: Text('${t.body}\n\n${ticketStatusLabel(context, t.status)} · ${t.priority == 'high' ? l.priorityHigh : l.priorityNormal} · ${df.format(t.createdAt.toLocal())}'),
                      isThreeLine: true,
                    ),
                  ),
                  ...?msgs.value?.map((m) => Align(
                        alignment: m.senderId == uid ? Alignment.centerRight : Alignment.centerLeft,
                        child: Card(
                          color: m.senderId == uid ? Theme.of(context).colorScheme.primaryContainer : null,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(m.body), Text(df.format(m.createdAt.toLocal()), style: Theme.of(context).textTheme.labelSmall)],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: _reply, decoration: InputDecoration(hintText: l.reply, border: const OutlineInputBorder(), isDense: true), minLines: 1, maxLines: 4)),
                    IconButton.filled(onPressed: _send, icon: const Icon(Icons.send)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
