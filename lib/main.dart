import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/router.dart';
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
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF8B4513));
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
      theme: ThemeData(colorScheme: scheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B4513), brightness: Brightness.dark), useMaterial3: true),
    );
  }
}
