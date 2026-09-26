import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n_ext.dart';

const brandBrown = Color(0xFF9C5426);
const brandBrownDark = Color(0xFF7A3E14);
const brandGreen = Color(0xFF3F8A3D);
const brandLeaf = Color(0xFF7BBE63);
const brandGold = Color(0xFFD9A441);
const brandCream = Color(0xFFFBF1E3);

/// The tree-with-roots mark, drawn in Dart so it scales from 24 px to 512 px
/// without an SVG dependency. Source of truth: assets/branding/logo.svg.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 48, this.withBackground = true});
  final double size;
  final bool withBackground;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _LogoPainter(withBackground: withBackground));
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.withBackground});
  final bool withBackground;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 512;
    canvas.scale(s);
    if (withBackground) {
      canvas.drawCircle(
        const Offset(256, 256),
        244,
        Paint()
          ..shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFF8EE), Color(0xFFF6E7D0)])
              .createShader(const Rect.fromLTWH(12, 12, 488, 488)),
      );
      canvas.drawCircle(const Offset(256, 256), 244, Paint()..color = brandGold..style = PaintingStyle.stroke..strokeWidth = 6);
      canvas.drawOval(const Rect.fromLTWH(106, 404, 300, 28), Paint()..color = brandGold.withValues(alpha: 0.35));
    }
    final wood = Paint()
      ..shader = const LinearGradient(colors: [brandBrownDark, brandBrown, brandBrownDark]).createShader(const Rect.fromLTWH(150, 246, 212, 190));
    final root = Paint()
      ..shader = wood.shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    for (final path in [
      Path()..moveTo(256, 372)..cubicTo(240, 392, 200, 396, 150, 420),
      Path()..moveTo(256, 372)..cubicTo(272, 392, 312, 396, 362, 420),
      Path()..moveTo(250, 376)..cubicTo(236, 400, 214, 408, 196, 428),
      Path()..moveTo(262, 376)..cubicTo(276, 400, 298, 408, 316, 428),
      Path()..moveTo(256, 378)..lineTo(256, 430),
    ]) {
      canvas.drawPath(path, root);
    }
    canvas.drawPath(
      Path()..moveTo(234, 246)..cubicTo(240, 300, 236, 340, 220, 384)..lineTo(292, 384)..cubicTo(276, 340, 272, 300, 278, 246)..close(),
      wood,
    );
    final canopy = Paint()
      ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [brandLeaf, brandGreen])
          .createShader(const Rect.fromLTWH(104, 58, 304, 264));
    for (final (c, r) in [(const Offset(256, 150), 92.0), (const Offset(178, 206), 74.0), (const Offset(334, 206), 74.0), (const Offset(206, 262), 60.0), (const Offset(306, 262), 60.0), (const Offset(256, 240), 68.0)]) {
      canvas.drawCircle(c, r, canopy);
    }
    canvas.drawPath(
      Path()..moveTo(196, 118)..cubicTo(214, 88, 262, 74, 300, 92)..cubicTo(268, 94, 230, 108, 206, 140)..close(),
      Paint()..color = Colors.white.withValues(alpha: 0.22),
    );
    final link = Paint()
      ..color = const Color(0xFFFFF8EE)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final (a, b) in [
      (const Offset(256, 150), const Offset(206, 200)), (const Offset(256, 150), const Offset(306, 200)),
      (const Offset(206, 200), const Offset(180, 250)), (const Offset(206, 200), const Offset(232, 250)),
      (const Offset(306, 200), const Offset(280, 250)), (const Offset(306, 200), const Offset(332, 250)),
    ]) {
      canvas.drawLine(a, b, link);
    }
    final node = Paint()..color = const Color(0xFFFFF8EE);
    for (final (c, r) in [(const Offset(256, 150), 15.0), (const Offset(206, 200), 12.0), (const Offset(306, 200), 12.0), (const Offset(180, 250), 9.0), (const Offset(232, 250), 9.0), (const Offset(280, 250), 9.0), (const Offset(332, 250), 9.0)]) {
      canvas.drawCircle(c, r, node);
    }
    canvas.drawCircle(const Offset(256, 150), 7, Paint()..color = brandGold);
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.withBackground != withBackground;
}

/// Community wordmark in the Baloo display face; follows the active locale.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.scale = 1, this.color, this.accent});
  final double scale;
  final Color? color;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final (top, bottom, family) = switch (lang) {
      'gu' => ('શ્રી મચ્છુકાઠિયા', 'સઈ સુથાર સમાજ', 'BalooBhai2'),
      'hi' => ('श्री मच्छुकाठिया', 'सई सुथार समाज', 'Baloo2'),
      _ => ('Machhukathiya', 'Sai Suthar Samaj', 'BalooBhai2'),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(top,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: family, fontSize: 26 * scale, fontWeight: FontWeight.w700, height: 1.15, color: color ?? brandBrown)),
        Text(bottom,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: family, fontSize: 17 * scale, fontWeight: FontWeight.w600, height: 1.1, letterSpacing: lang == 'en' ? 1.5 : 0, color: accent ?? brandGreen)),
      ],
    );
  }
}

/// Rotating salutations for the home bar and welcome screen.
List<String> greetings(BuildContext context) => [
      context.l.greetingJayShreeKrishna,
      context.l.greetingJayMataji,
      context.l.greetingRamRam,
      context.l.greetingJayVishwakarma,
    ];

String randomGreeting(BuildContext context, [Random? rng]) {
  final g = greetings(context);
  return g[(rng ?? Random()).nextInt(g.length)];
}
