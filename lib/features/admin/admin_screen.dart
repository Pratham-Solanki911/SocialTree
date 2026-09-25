import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

/// Membership approvals, roles and plans. Server-side guard trigger enforces
/// that only admins can change these columns.
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final profiles = ref.watch(allProfilesProvider);
    final uid = ref.watch(currentUserIdProvider);

    Future<void> patch(String id, Map<String, dynamic> m) async {
      try {
        await ref.read(reposProvider).adminPatchProfile(id, m);
        ref.invalidate(allProfilesProvider);
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.admin)),
      body: AsyncBody<List<Profile>>(
        value: profiles,
        onRetry: () => ref.invalidate(allProfilesProvider),
        builder: (list) {
          final pending = list.where((p) => p.status == 'pending').toList();
          final others = list.where((p) => p.status != 'pending').toList();
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(allProfilesProvider),
            child: ListView(
              children: [
                ListTile(leading: const Icon(Icons.how_to_reg_outlined), title: Text(l.claimsTitle), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/claims')),
                SectionTitle(l.pendingMembers),
                if (pending.isEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(l.noPending)),
                for (final p in pending)
                  ListTile(
                    leading: const Icon(Icons.hourglass_top_outlined),
                    title: Text(p.displayName),
                    subtitle: Text(p.email ?? ''),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        FilledButton.tonal(
                          onPressed: () => patch(p.id, {'status': 'approved', 'approved_by': uid, 'approved_at': DateTime.now().toIso8601String()}),
                          child: Text(l.approve),
                        ),
                        TextButton(onPressed: () => patch(p.id, {'status': 'rejected'}), child: Text(l.reject)),
                      ],
                    ),
                  ),
                SectionTitle(l.allMembers),
                for (final p in others)
                  ExpansionTile(
                    leading: Icon(p.status == 'approved' ? Icons.check_circle_outline : Icons.block_outlined, color: p.status == 'approved' ? Colors.green : Colors.red),
                    title: Text(p.displayName),
                    subtitle: Text([p.email ?? '', p.status, if (p.isAdmin) l.adminBadge].where((s) => s.isNotEmpty).join(' · ')),
                    children: [
                      SwitchListTile(title: Text(l.adminBadge), value: p.isAdmin, onChanged: p.id == uid ? null : (v) => patch(p.id, {'is_admin': v})),
                      SwitchListTile(title: Text(l.supportAgent), value: p.isSupport, onChanged: (v) => patch(p.id, {'is_support': v})),
                      OverflowBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          if (p.status != 'approved') TextButton(onPressed: () => patch(p.id, {'status': 'approved'}), child: Text(l.approve)),
                          if (p.status == 'approved' && p.id != uid) TextButton(onPressed: () => patch(p.id, {'status': 'blocked'}), child: Text(l.block)),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
