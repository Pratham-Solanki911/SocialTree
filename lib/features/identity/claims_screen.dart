import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';

String claimStatusLabel(BuildContext context, String s) => switch (s) {
      'approved' => context.l.statusApproved,
      'rejected' => context.l.statusRejected,
      'withdrawn' => context.l.statusWithdrawn,
      _ => context.l.statusPending,
    };

/// "This is me" requests I can answer, and my own.
class ClaimsScreen extends ConsumerWidget {
  const ClaimsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final requests = ref.watch(claimRequestsProvider);
    final uid = ref.watch(currentUserIdProvider);
    final profiles = ref.watch(approvedProfilesProvider).value ?? const <Profile>[];
    String name(String id) => profiles.where((p) => p.id == id).firstOrNull?.displayName ?? '?';
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());

    Future<void> act(Future<void> Function() job) async {
      try {
        await job();
        ref.invalidate(claimRequestsProvider);
        ref.invalidate(myPersonProvider);
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.claimsTitle)),
      body: AsyncBody<List<ClaimRequest>>(
        value: requests,
        onRetry: () => ref.invalidate(claimRequestsProvider),
        builder: (list) {
          final pending = list.where((c) => c.status == 'pending').toList();
          final past = list.where((c) => c.status != 'pending').toList();
          if (list.isEmpty) return EmptyState(text: l.noRequests, icon: Icons.how_to_reg_outlined);
          return ListView(
            children: [
              SectionTitle(l.pendingRequests),
              for (final c in pending)
                _RequestCard(
                  request: c,
                  requesterName: name(c.requesterId),
                  mine: c.requesterId == uid,
                  onApprove: () => act(() => ref.read(reposProvider).decideClaim(c.id, true)),
                  onReject: () => act(() => ref.read(reposProvider).decideClaim(c.id, false)),
                  onWithdraw: () => act(() => ref.read(reposProvider).withdrawClaim(c.id)),
                ),
              if (pending.isEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(l.noRequests)),
              if (past.isNotEmpty) SectionTitle(l.pastRequests),
              for (final c in past)
                ListTile(
                  leading: Icon(c.status == 'approved' ? Icons.check_circle_outline : Icons.cancel_outlined, color: c.status == 'approved' ? Colors.green : null),
                  title: Text(l.requestFrom(name(c.requesterId))),
                  subtitle: Text('${claimStatusLabel(context, c.status)} · ${df.format((c.decidedAt ?? c.createdAt).toLocal())}${c.reason != null ? '\n${c.reason}' : ''}'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RequestCard extends ConsumerWidget {
  const _RequestCard({required this.request, required this.requesterName, required this.mine, required this.onApprove, required this.onReject, required this.onWithdraw});
  final ClaimRequest request;
  final String requesterName;
  final bool mine;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final person = ref.watch(personProvider(request.personId)).value;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(title: Text(l.requestFrom(requesterName)), subtitle: request.message == null ? null : Text(request.message!)),
          if (person != null) PersonTile(person: person, trailing: const SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: mine
                ? OutlinedButton(onPressed: onWithdraw, child: Text(l.cancelRequest))
                : Row(children: [
                    Expanded(child: FilledButton.icon(onPressed: onApprove, icon: const Icon(Icons.check), label: Text(l.confirmYes))),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton.icon(onPressed: onReject, icon: const Icon(Icons.close), label: Text(l.confirmNo))),
                  ]),
          ),
        ],
      ),
    );
  }
}
