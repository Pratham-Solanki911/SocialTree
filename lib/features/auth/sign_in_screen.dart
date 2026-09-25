import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/branding.dart';
import '../../core/env.dart';
import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _busy = false;

  Future<void> _google() async {
    setState(() => _busy = true);
    try {
      // Browser-based OAuth: no Google SDK, no SHA-1 fingerprints; the deep
      // link in Env.authRedirect brings the session back on mobile.
      await ref.read(supabaseProvider).auth.signInWithOAuth(
            OAuthProvider.google,
            // Web: come back to this exact page (works under a /repo/ base href
            // on GitHub Pages). Mobile: the app's deep link.
            redirectTo: kIsWeb ? Uri.base.removeFragment().toString() : Env.authRedirect,
            authScreenLaunchMode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
          );
    } catch (e) {
      if (mounted) showMessage(context, context.l.signInFailed(friendlyError(e)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoMark(size: 120),
              const SizedBox(height: 16),
              const Wordmark(scale: 1.2),
              const SizedBox(height: 8),
              Text(l.signInTagline, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _busy ? null : _google,
                icon: _busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.login),
                label: Text(l.signInWithGoogle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
