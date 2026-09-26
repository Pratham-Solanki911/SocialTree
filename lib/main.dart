import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/env.dart';
import 'core/l10n_ext.dart';
import 'core/supabase_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Env.isConfigured) {
    await Supabase.initialize(url: Env.supabaseUrl, publishableKey: Env.supabaseAnonKey);
  }
  runApp(const ProviderScope(child: SocialTreeApp()));
}

class SocialTreeApp extends ConsumerWidget {
  const SocialTreeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Env.isConfigured ? ref.watch(localeProvider) : null;
    final largeText = Env.isConfigured && (ref.watch(myProfileProvider).value?.largeText ?? false);
    return MaterialApp.router(
      title: 'SocialTree',
      routerConfig: ref.watch(routerProvider),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Elders: one switch for bigger letters everywhere, saved on the profile.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: largeText ? 1.3 : 1.0,
        maxScaleFactor: 2.0,
        child: child ?? const SizedBox.shrink(),
      ),
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
    );
  }
}
