import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/branding.dart';
import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';

/// First login: a salutation and the language choice. Saved to the profile,
/// so it follows the member across devices.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  String _locale = 'gu';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    // Preview strings in the language being chosen.
    return Localizations.override(
      context: context,
      locale: Locale(_locale),
      child: Builder(builder: (context) {
        final l = context.l;
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LogoMark(size: 96),
                    const SizedBox(height: 12),
                    const Wordmark(),
                    const SizedBox(height: 20),
                    Text(randomGreeting(context), style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(l.welcomeTitle, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    Text(l.chooseLanguage, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'gu', label: Text('ગુજરાતી')),
                        ButtonSegment(value: 'hi', label: Text('हिन्दी')),
                        ButtonSegment(value: 'en', label: Text('English')),
                      ],
                      selected: {_locale},
                      onSelectionChanged: (s) => setState(() => _locale = s.first),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              setState(() => _busy = true);
                              try {
                                await ref.read(reposProvider).updateMyProfile({'locale': _locale});
                              } catch (e) {
                                if (context.mounted) showError(context, e);
                              } finally {
                                if (mounted) setState(() => _busy = false);
                              }
                            },
                      child: Text(l.continueLabel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
