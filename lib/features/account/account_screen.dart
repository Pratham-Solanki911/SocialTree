import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../chat/conversations_screen.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final profile = ref.watch(myProfileProvider).value;
    final me = ref.watch(myPersonProvider).value;
    final members = ref.watch(approvedProfilesProvider).value ?? const <Profile>[];
    if (profile == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final successor = members.where((m) => m.id == profile.successorId).firstOrNull;

    Future<void> patch(Map<String, dynamic> m) async {
      try {
        await ref.read(reposProvider).updateMyProfile(m);
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.navAccount)),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: profile.avatarUrl == null ? null : NetworkImage(profile.avatarUrl!),
              child: profile.avatarUrl == null ? Text(profile.displayName[0].toUpperCase()) : null,
            ),
            title: Text(profile.displayName),
            subtitle: Text(profile.email ?? ''),
            trailing: Wrap(
              spacing: 4,
              children: [
                if (profile.isAdmin) Chip(label: Text(l.adminBadge), visualDensity: VisualDensity.compact),
                Chip(label: Text(profile.isPremium ? l.planPremium : l.planFree), visualDensity: VisualDensity.compact),
              ],
            ),
          ),
          SectionTitle(l.yourRecord),
          if (me == null)
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: Text(l.createMyProfile),
              subtitle: Text(l.noProfileYet),
              isThreeLine: true,
              onTap: () => context.push('/persons/new'),
            )
          else
            ListTile(
              leading: PersonAvatar(path: me.passportPhotoPath, initials: me.initials, size: 36),
              title: Text(me.fullName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/persons/${me.id}'),
            ),
          SectionTitle(l.language),
          RadioGroup<String>(
            groupValue: profile.locale,
            onChanged: (v) => patch({'locale': v}),
            child: Column(
              children: [
                RadioListTile<String>(value: 'en', title: Text(l.english)),
                RadioListTile<String>(value: 'gu', title: Text(l.gujarati)),
                RadioListTile<String>(value: 'hi', title: Text(l.hindi)),
              ],
            ),
          ),
          SectionTitle(l.plan),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(profile.isPremium ? l.planPremium : l.planFree),
            subtitle: Text(l.planInfo),
          ),
          SectionTitle(l.digitalAccount),
          ListTile(
            leading: const Icon(Icons.family_restroom_outlined),
            title: Text(l.successor),
            subtitle: Text(successor?.displayName ?? l.successorInfo),
            trailing: successor == null ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => patch({'successor_id': null})),
            onTap: () async {
              final m = await pickMember(context, ref);
              if (m != null) await patch({'successor_id': m.id});
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l.exportData),
            onTap: () => _export(context, ref),
          ),
          if (profile.isAdmin) ...[
            SectionTitle(l.admin),
            ListTile(leading: const Icon(Icons.admin_panel_settings_outlined), title: Text(l.admin), onTap: () => context.push('/admin')),
          ],
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => ref.read(supabaseProvider).auth.signOut(),
              icon: const Icon(Icons.logout),
              label: Text(l.signOut),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    try {
      final data = await ref.read(reposProvider).exportMyData();
      final json = const JsonEncoder.withIndent('  ').convert(data);
      final name = 'socialtree-export-${DateTime.now().toIso8601String().substring(0, 10)}.json';
      if (kIsWeb) {
        await SharePlus.instance.share(ShareParams(text: json, subject: name));
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$name');
        await file.writeAsString(json);
        await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'application/json')], subject: name));
      }
      if (context.mounted) showMessage(context, l.exportDone);
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }
}
