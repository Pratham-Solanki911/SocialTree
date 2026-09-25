import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';

/// Shown while the profile loads and while membership is not yet approved.
/// The profile stream flips this to /home automatically once approved.
class PendingScreen extends ConsumerWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final profile = ref.watch(myProfileProvider).value;
    final (icon, body) = switch (profile?.status) {
      'rejected' => (Icons.block_outlined, l.rejectedBody),
      'blocked' => (Icons.gpp_bad_outlined, l.blockedBody),
      _ => (Icons.hourglass_top_outlined, l.pendingBody),
    };
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (profile == null) const CircularProgressIndicator() else Icon(icon, size: 64),
              const SizedBox(height: 16),
              Text(l.pendingTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
              if (profile?.email != null) ...[const SizedBox(height: 8), Text(profile!.email!)],
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => ref.read(supabaseProvider).auth.signOut(),
                child: Text(l.signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
