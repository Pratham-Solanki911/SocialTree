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
            redirectTo: kIsWeb ? Uri.base.removeFragment().toString() : Env.authRedirect,
            authScreenLaunchMode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
          );
    } catch (e) {
      if (mounted) showMessage(context, context.l.signInFailed(friendlyError(context, e)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark ? const [Color(0xFF2A2019), Color(0xFF1A1512)] : const [Color(0xFFFFF6E8), Color(0xFFFCF8F2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LogoMark(size: 150),
                    const SizedBox(height: 20),
                    const Wordmark(scale: 1.25),
                    const SizedBox(height: 10),
                    Text(l.signInTagline, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 40),
                    FilledButton(
                      onPressed: _busy ? null : _google,
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(60)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_busy)
                            const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          else
                            const _GoogleG(),
                          const SizedBox(width: 14),
                          Flexible(child: Text(l.signInWithGoogle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(l.samajName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small "G" badge so the button is recognisable without the Google SDK.
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) => Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: const Text('G', style: TextStyle(color: Color(0xFF4285F4), fontSize: 19, fontWeight: FontWeight.w800, height: 1)),
      );
}
