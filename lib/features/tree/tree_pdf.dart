import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import 'tree_pdf_layout.dart';

/// Strings the renderer needs, resolved from the active locale so the PDF
/// matches the app language.
class PdfStrings {
  PdfStrings({required this.samaj, required this.wordmarkTop, required this.wordmarkBottom, required this.title, required this.footer, required this.page, required this.born, required this.died, required this.gotra, required this.village});
  final String samaj;
  final String wordmarkTop;
  final String wordmarkBottom;
  final String title;
  final String footer;
  final String Function(int page, int total) page;
  final String Function(String) born;
  final String Function(String) died;
  final String gotra;
  final String village;
}

class PdfFonts {
  PdfFonts({required this.latin, required this.gujarati, required this.devanagari});
  final pw.Font latin;
  final pw.Font gujarati;
  final pw.Font devanagari;

  static Future<PdfFonts> fromAssets() async => PdfFonts(
        latin: pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans.ttf')),
        gujarati: pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansGujarati.ttf')),
        devanagari: pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansDevanagari.ttf')),
      );
}

const _brown = PdfColor.fromInt(0xFF8B4513);
const _green = PdfColor.fromInt(0xFF3E7D3A);
const _cream = PdfColor.fromInt(0xFFFFF4E6);
const _pink = PdfColor.fromInt(0xFFF8BBD0);
const _blue = PdfColor.fromInt(0xFFBBDEFB);

/// Landscape A4 pages. The tree is scaled to fit down to 55%; wider trees are
/// sliced into side-by-side pages with a page index in the footer.
Future<Uint8List> buildTreePdf({
  required PdfTreeLayout layout,
  required PdfStrings s,
  required PdfFonts fonts,
  Map<String, Uint8List> photos = const {},
  DateTime? now,
}) async {
  final doc = pw.Document(title: s.title, author: 'SocialTree', theme: pw.ThemeData.withFont(base: fonts.latin, bold: fonts.latin, fontFallback: [fonts.gujarati, fonts.devanagari]));
  const format = PdfPageFormat.a4;
  final pageW = format.landscape.width - 40;
  final pageH = format.landscape.height - 40 - 70 - 24; // margins, header, footer
  final fitScale = (pageW / layout.width).clamp(0.0, 1.0);
  final scale = fitScale < 0.55 ? 0.55 : fitScale;
  final sliceW = pageW / scale;
  final pages = (layout.width / sliceW).ceil().clamp(1, 20);
  final vScale = (pageH / (layout.height * scale)).clamp(0.0, 1.0);
  final finalScale = scale * vScale;
  final date = DateFormat.yMMMd().format(now ?? DateTime.now());

  for (var i = 0; i < pages; i++) {
    final offsetX = i * sliceW;
    doc.addPage(pw.Page(
      pageFormat: format.landscape,
      margin: const pw.EdgeInsets.all(20),
      build: (ctx) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _header(s),
        pw.SizedBox(height: 8),
        pw.Expanded(
          child: pw.ClipRect(
            child: pw.CustomPaint(
              size: PdfPoint(pageW, pageH),
              painter: (canvas, size) => _paintTree(ctx, canvas, size, layout, s, fonts, photos, finalScale, offsetX),
            ),
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(s.footer.replaceAll('{date}', date), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Text(s.page(i + 1, pages), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        ]),
      ]),
    ));
  }
  return doc.save();
}

pw.Widget _header(PdfStrings s) => pw.Row(children: [
      _logo(),
      pw.SizedBox(width: 12),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(s.wordmarkTop, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: _brown, letterSpacing: 1.5)),
        pw.Text(s.wordmarkBottom, style: const pw.TextStyle(fontSize: 9, color: _green, letterSpacing: 2.5)),
      ]),
      pw.Spacer(),
      pw.Text(s.title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
    ]);

/// Vector version of the logo mark, drawn with the same geometry as the app.
pw.Widget _logo() => pw.SizedBox(
      width: 44,
      height: 44,
      child: pw.CustomPaint(painter: (canvas, size) {
        final k = size.x / 512;
        canvas
          ..setFillColor(_cream)
          ..drawEllipse(256 * k, 256 * k, 240 * k, 240 * k)
          ..fillPath()
          ..setFillColor(_green);
        for (final (cx, cy, r) in [(256, 150, 96), (170, 210, 82), (342, 210, 82), (256, 230, 90)]) {
          canvas
            ..drawEllipse(cx * k, (512 - cy) * k, r * k, r * k)
            ..fillPath();
        }
        canvas
          ..setFillColor(_brown)
          ..drawRect(238 * k, (512 - 380) * k, 36 * k, 130 * k)
          ..fillPath()
          ..moveTo(256 * k, (512 - 370) * k)
          ..curveTo(216 * k, (512 - 410) * k, 166 * k, (512 - 400) * k, 106 * k, (512 - 440) * k)
          ..curveTo(166 * k, (512 - 420) * k, 206 * k, (512 - 410) * k, 256 * k, (512 - 400) * k)
          ..curveTo(306 * k, (512 - 410) * k, 346 * k, (512 - 420) * k, 406 * k, (512 - 440) * k)
          ..curveTo(346 * k, (512 - 400) * k, 296 * k, (512 - 410) * k, 256 * k, (512 - 370) * k)
          ..closePath()
          ..fillPath();
      }),
    );

void _paintTree(pw.Context ctx, PdfGraphics canvas, PdfPoint size, PdfTreeLayout layout, PdfStrings s, PdfFonts fonts, Map<String, Uint8List> photos, double scale, double offsetX) {
  // PDF y grows upward; flip so row 0 (oldest generation) is at the top.
  double px(double x) => (x - offsetX) * scale;
  double py(double y) => size.y - (y + PdfTreeLayout.cardH) * scale;
  const cw = PdfTreeLayout.cardW;
  const ch = PdfTreeLayout.cardH;

  canvas.setStrokeColor(PdfColors.grey600);
  canvas.setLineWidth(1);
  for (final (parent, child) in layout.parentEdges) {
    final a = layout.nodes[parent]!;
    final b = layout.nodes[child]!;
    final x1 = px(a.x + cw / 2), y1 = py(a.y);
    final x2 = px(b.x + cw / 2), y2 = py(b.y) + ch * scale;
    final mid = (y1 + y2) / 2;
    canvas
      ..moveTo(x1, y1)
      ..lineTo(x1, mid)
      ..lineTo(x2, mid)
      ..lineTo(x2, y2)
      ..strokePath();
  }
  canvas.setStrokeColor(_brown);
  canvas.setLineWidth(1.5);
  for (final (a0, b0) in layout.spouseEdges) {
    final a = layout.nodes[a0]!;
    final b = layout.nodes[b0]!;
    if (a.gen != b.gen) continue;
    final (l, r) = a.x < b.x ? (a, b) : (b, a);
    final y = py(l.y) + ch * scale / 2;
    canvas
      ..moveTo(px(l.x + cw), y)
      ..lineTo(px(r.x), y)
      ..strokePath();
  }

  for (final row in layout.rows) {
    for (final n in row) {
      final x = px(n.x), y = py(n.y);
      if (x + cw * scale < 0 || x > size.x) continue;
      final p = n.person;
      canvas
        ..setFillColor(p.gender == 'female' ? _pink : p.gender == 'male' ? _blue : PdfColors.grey300)
        ..drawRRect(x, y, cw * scale, ch * scale, 4 * scale, 4 * scale)
        ..fillPath()
        ..setStrokeColor(n.person.id == layout.nodes.keys.first ? _brown : PdfColors.grey700)
        ..setLineWidth(0.6)
        ..drawRRect(x, y, cw * scale, ch * scale, 4 * scale, 4 * scale)
        ..strokePath();
      var tx = x + 4 * scale;
      final photo = photos[p.id];
      if (photo != null) {
        final img = PdfImage.jpeg(ctx.document, image: photo);
        canvas.drawImage(img, x + 3 * scale, y + 3 * scale, 39 * scale, (ch - 6) * scale);
        tx += 42 * scale;
      }
      final years = [
        if (p.dob != null) s.born('${p.dob!.year}'),
        if (!p.isAlive) s.died(p.dod != null ? '${p.dod!.year}' : ''),
      ].join('  ');
      final meta = [if (p.nativeVillage != null) p.nativeVillage!, if (n.gotraName != null) n.gotraName!].join(' · ');
      _text(ctx, canvas, fonts, p.fullName, tx, y + (ch - 16) * scale, 8.5 * scale, bold: true);
      _text(ctx, canvas, fonts, years, tx, y + (ch - 30) * scale, 7 * scale);
      _text(ctx, canvas, fonts, meta, tx, y + (ch - 43) * scale, 6.5 * scale, color: PdfColors.grey800);
    }
  }
}

/// Draws a string glyph-run by glyph-run with the font that covers each
/// script, so Gujarati and Hindi names render next to Latin text.
void _text(pw.Context ctx, PdfGraphics canvas, PdfFonts fonts, String text, double x, double y, double size, {bool bold = false, PdfColor color = PdfColors.black}) {
  if (text.isEmpty) return;
  canvas.setFillColor(color);
  var cx = x;
  for (final run in _runs(text)) {
    final font = switch (run.$1) { 'gu' => fonts.gujarati, 'hi' => fonts.devanagari, _ => fonts.latin };
    final pdfFont = font.getFont(ctx);
    canvas.drawString(pdfFont, size, run.$2, cx, y);
    cx += pdfFont.stringMetrics(run.$2).advanceWidth * size;
  }
}

/// Splits text into (script, chunk) runs by Unicode block.
List<(String, String)> _runs(String text) {
  final out = <(String, String)>[];
  final buf = StringBuffer();
  String? cur;
  for (final r in text.runes) {
    final script = r >= 0x0A80 && r <= 0x0AFF ? 'gu' : r >= 0x0900 && r <= 0x097F ? 'hi' : 'la';
    if (cur != null && script != cur && script != 'la' || (cur != null && cur != 'la' && script == 'la' && r != 0x20)) {
      out.add((cur, buf.toString()));
      buf.clear();
    }
    cur = script == 'la' && cur != null && buf.isNotEmpty && r == 0x20 ? cur : script;
    buf.writeCharCode(r);
  }
  if (buf.isNotEmpty) out.add((cur ?? 'la', buf.toString()));
  return out;
}

/// Fetches data, renders, and hands the file to the platform share/download.
Future<void> downloadTreePdf(BuildContext context, WidgetRef ref, Person root) async {
  final l = context.l;
  var includePhotos = false;
  final go = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(l.downloadTreePdf),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l.treePdfInfo),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.includePhotos), value: includePhotos, onChanged: (v) => setState(() => includePhotos = v)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.downloadTreePdf)),
        ],
      ),
    ),
  );
  if (go != true || !context.mounted) return;
  showMessage(context, l.generatingPdf);
  try {
    final repos = ref.read(reposProvider);
    final data = await repos.treePdfData(root.id);
    final layout = PdfTreeLayout.build(data);
    final photos = <String, Uint8List>{};
    if (includePhotos) {
      // mytail: cap at 60 photos (~6 MB) so the PDF stays shareable on WhatsApp.
      var n = 0;
      for (final node in layout.nodes.values) {
        final path = node.person.passportPhotoPath;
        if (path == null || n >= 60) continue;
        try {
          final url = await repos.signedUrl(path);
          final bytes = await NetworkAssetBundle(Uri.parse(url)).load('');
          photos[node.person.id] = bytes.buffer.asUint8List();
          n++;
        } catch (_) {/* skip missing photo */}
      }
    }
    if (!context.mounted) return;
    final lang = Localizations.localeOf(context).languageCode;
    final (top, bottom) = switch (lang) {
      'gu' => ('શ્રી મચ્છુકાઠિયા', 'સઈ સુથાર સમાજ'),
      'hi' => ('श्री मच्छुकाठिया', 'सई सुथार समाज'),
      _ => ('MACHHUKATHIYA', 'SAI SUTHAR SAMAJ'),
    };
    final strings = PdfStrings(
      samaj: l.samajName,
      wordmarkTop: top,
      wordmarkBottom: bottom,
      title: l.treeOf(root.fullName),
      footer: l.pdfGeneratedOn('{date}'),
      page: l.pageOf,
      born: l.born,
      died: l.died,
      gotra: l.gotra,
      village: l.nativeVillage,
    );
    final bytes = await buildTreePdf(layout: layout, s: strings, fonts: await PdfFonts.fromAssets(), photos: photos);
    final slug = root.shortName.replaceAll(RegExp(r'[^A-Za-z0-9઀-૿ऀ-ॿ]+'), '-').toLowerCase();
    await Printing.sharePdf(bytes: bytes, filename: 'socialtree-tree-$slug-${DateTime.now().toIso8601String().substring(0, 10)}.pdf');
    if (context.mounted) showMessage(context, l.pdfReady);
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}
