import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n_ext.dart';

const brandBrown = Color(0xFF8B4513);
const brandGreen = Color(0xFF3E7D3A);
const brandLeaf = Color(0xFF6FAE5B);
const brandCream = Color(0xFFFFF4E6);

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
      canvas.drawCircle(const Offset(256, 256), 240, Paint()..color = brandCream);
    }
    final leaf = Paint()
      ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [brandLeaf, brandGreen])
          .createShader(const Rect.fromLTWH(74, 54, 364, 266));
    for (final (c, r) in [(const Offset(256, 150), 96.0), (const Offset(170, 210), 82.0), (const Offset(342, 210), 82.0), (const Offset(256, 230), 90.0)]) {
      canvas.drawCircle(c, r, leaf);
    }
    final wood = Paint()..color = brandBrown;
    canvas.drawRect(const Rect.fromLTWH(238, 250, 36, 130), wood);
    final roots = Path()
      ..moveTo(256, 370)
      ..cubicTo(216, 410, 166, 400, 106, 440)
      ..cubicTo(166, 420, 206, 410, 256, 400)
      ..cubicTo(306, 410, 346, 420, 406, 440)
      ..cubicTo(346, 400, 296, 410, 256, 370)
      ..close();
    canvas.drawPath(roots, wood);
    canvas.drawPath(Path()..moveTo(256, 372)..cubicTo(246, 402, 244, 427, 250, 450)..lineTo(262, 450)..cubicTo(268, 427, 266, 402, 256, 372)..close(), wood);
    // Family nodes and links inside the canopy.
    final node = Paint()..color = brandCream.withValues(alpha: 0.9);
    final link = Paint()
      ..color = brandCream.withValues(alpha: 0.9)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(Path()..moveTo(256, 150)..lineTo(220, 185)..lineTo(186, 215), link);
    canvas.drawPath(Path()..moveTo(256, 150)..lineTo(292, 185)..lineTo(326, 215), link);
    canvas.drawLine(const Offset(256, 150), const Offset(256, 232), link);
    for (final (c, r) in [(const Offset(256, 150), 10.0), (const Offset(186, 215), 10.0), (const Offset(326, 215), 10.0), (const Offset(256, 232), 10.0), (const Offset(220, 185), 7.0), (const Offset(292, 185), 7.0)]) {
      canvas.drawCircle(c, r, node);
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.withBackground != withBackground;
}

/// Community wordmark as styled text; follows the active locale.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.scale = 1, this.color});
  final double scale;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final (top, bottom) = switch (lang) {
      'gu' => ('શ્રી મચ્છુકાઠિયા', 'સઈ સુથાર સમાજ'),
      'hi' => ('श्री मच्छुकाठिया', 'सई सुथार समाज'),
      _ => ('MACHHUKATHIYA', 'SAI SUTHAR SAMAJ'),
    };
    final latin = lang == 'en';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(top,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.w800, letterSpacing: latin ? 2.5 : 0, color: color ?? brandBrown, fontFamily: latin ? 'serif' : null)),
        Container(height: 1.5, width: 120 * scale, margin: EdgeInsets.symmetric(vertical: 4 * scale), color: (color ?? brandBrown).withValues(alpha: 0.5)),
        Text(bottom,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13 * scale, fontWeight: FontWeight.w600, letterSpacing: latin ? 4 : 0, color: color ?? brandGreen, fontFamily: latin ? 'serif' : null)),
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
