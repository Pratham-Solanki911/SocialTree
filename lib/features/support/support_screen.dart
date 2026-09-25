import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

String ticketStatusLabel(BuildContext context, String s) => switch (s) {
      'in_progress' => context.l.statusInProgress,
      'resolved' => context.l.statusResolved,
      _ => context.l.statusOpen,
    };

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final tickets = ref.watch(ticketsProvider);
    final profile = ref.watch(myProfileProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.support)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.newTicket),
      ),
      body: AsyncBody<List<SupportTicket>>(
        value: tickets,
        onRetry: () => ref.invalidate(ticketsProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(text: l.noTickets, icon: Icons.support_agent_outlined)
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(ticketsProvider),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final t = list[i];
                    return ListTile(
                      leading: Icon(t.priority == 'high' ? Icons.priority_high : Icons.low_priority, color: t.priority == 'high' ? Colors.red : null),
                      title: Text(t.subject),
                      subtitle: Text([
                        ticketStatusLabel(context, t.status),
                        if (profile?.canSupport == true && t.userName != null) t.userName!,
                      ].join(' · ')),
                      trailing: Chip(label: Text(t.priority == 'high' ? l.priorityHigh : l.priorityNormal), visualDensity: VisualDensity.compact),
                      onTap: () => context.push('/support/${t.id}'),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    final subject = TextEditingController();
    final body = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.newTicket),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: subject, decoration: InputDecoration(labelText: l.subject), autofocus: true),
            TextField(controller: body, decoration: InputDecoration(labelText: l.message), maxLines: 4),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, subject.text.trim().isNotEmpty && body.text.trim().isNotEmpty), child: Text(l.send)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(reposProvider).createTicket(subject.text.trim(), body.text.trim());
      ref.invalidate(ticketsProvider);
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }
}
