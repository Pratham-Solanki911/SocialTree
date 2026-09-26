import 'package:flutter/material.dart';

import '../core/branding.dart';

/// Elder-friendly Material 3 theme: warm palette, larger type, tall touch
/// targets, labels always visible.
ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: brandBrown,
    primary: brightness == Brightness.light ? brandBrown : const Color(0xFFE8B38A),
    secondary: brandGreen,
    tertiary: brandGold,
    brightness: brightness,
  );
  final base = ThemeData(colorScheme: scheme, useMaterial3: true, brightness: brightness);
  final text = base.textTheme.copyWith(
    bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.35),
    bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 17, height: 1.35),
    labelLarge: base.textTheme.labelLarge?.copyWith(fontSize: 16),
    titleMedium: base.textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: base.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
    headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
  ).apply(fontFamilyFallback: const ['NotoSansGujarati', 'NotoSansDevanagari']);
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  return base.copyWith(
    textTheme: text,
    scaffoldBackgroundColor: brightness == Brightness.light ? const Color(0xFFFCF8F2) : null,
    visualDensity: VisualDensity.comfortable,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: brightness == Brightness.light ? const Color(0xFFFCF8F2) : null,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(shape: shape, elevation: 0, color: scheme.surfaceContainerLow, margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 12, horizontalTitleGap: 14),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size(56, 52), shape: shape, textStyle: text.labelLarge)),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(minimumSize: const Size(56, 52), shape: shape, textStyle: text.labelLarge)),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(minimumSize: const Size(48, 48), textStyle: text.labelLarge)),
    segmentedButtonTheme: SegmentedButtonThemeData(style: SegmentedButton.styleFrom(minimumSize: const Size(48, 48))),
    navigationBarTheme: NavigationBarThemeData(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 76,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(text.labelMedium?.copyWith(fontSize: 13)),
    ),
    chipTheme: base.chipTheme.copyWith(labelStyle: text.labelLarge?.copyWith(fontSize: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, contentTextStyle: text.bodyLarge?.copyWith(color: scheme.onInverseSurface)),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant.withValues(alpha: 0.5)),
  );
}
