import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:socialtree/features/tree/tree_pdf.dart';
import 'package:socialtree/features/tree/tree_pdf_layout.dart';

Map<String, dynamic> person(String id, String first, String last, {int gen = 0, String gender = 'male', int? dob, String? village}) => {
      'id': id,
      'family_id': 'f',
      'first_name': first,
      'last_name': last,
      'gender': gender,
      'gen': gen,
      'dob': dob == null ? null : '$dob-01-01',
      'native_village': village,
      'gotra_name': 'Khodiyar',
      'family_name': 'Solanki parivar',
      'phones': [],
    };

Map<String, dynamic> edge(String kind, String a, String b) => {'id': '$kind-$a-$b', 'kind': kind, 'person_id': a, 'related_id': b};

/// Five generations up and down, wide: 3 siblings per level, each married.
Map<String, dynamic> bigTree() {
  final persons = <Map<String, dynamic>>[];
  final rels = <Map<String, dynamic>>[];
  var prev = 'g0';
  persons.add(person('g0', 'Root', 'Solanki', dob: 1990, village: 'Morbi'));
  for (var g = -1; g >= -5; g--) {
    final father = 'f$g';
    persons.add(person(father, 'Father$g', 'Solanki', gen: g, dob: 1990 + 25 * g));
    persons.add(person('m$g', 'મા$g', 'સોલંકી', gen: g, gender: 'female', dob: 1992 + 25 * g));
    rels.add(edge('spouse', father, 'm$g'));
    rels.add(edge('parent', father, prev));
    rels.add(edge('parent', 'm$g', prev));
    for (var s = 0; s < 2; s++) {
      persons.add(person('s$g-$s', 'Uncle$g$s', 'Solanki', gen: g + 1, dob: 1993 + 25 * g + s));
      rels.add(edge('parent', father, 's$g-$s'));
    }
    prev = father;
  }
  var parents = ['g0'];
  for (var g = 1; g <= 5; g++) {
    final next = <String>[];
    for (final p in parents.take(3)) {
      for (var c = 0; c < 3; c++) {
        final id = 'c$g-$p-$c';
        persons.add(person(id, 'बेटा$g$c', 'Solanki', gen: g, dob: 1990 + 25 * g + c));
        rels.add(edge('parent', p, id));
        next.add(id);
      }
    }
    parents = next;
  }
  return {'root': 'g0', 'persons': persons, 'relationships': rels};
}

void main() {
  test('layout orders generations top-down and keeps couples adjacent', () {
    final layout = PdfTreeLayout.build(bigTree());
    expect(layout.rows.length, 11);
    expect(layout.rows.first.first.gen, -5);
    expect(layout.rows.last.first.gen, 5);
    final f = layout.nodes['f-1']!, m = layout.nodes['m-1']!;
    expect((f.x - m.x).abs(), PdfTreeLayout.cardW + PdfTreeLayout.hGap);
    expect(f.y, m.y);
    // children sit below their parents
    expect(layout.nodes['c1-g0-0']!.y, greaterThan(layout.nodes['g0']!.y));
    expect(layout.width, greaterThan(layout.rows.last.length * PdfTreeLayout.cardW));
  });

  test('renders a multi-page PDF with Gujarati and Hindi names', () async {
    final fonts = PdfFonts(
      latin: pw.Font.ttf(File('assets/fonts/NotoSans.ttf').readAsBytesSync().buffer.asByteData()),
      gujarati: pw.Font.ttf(File('assets/fonts/NotoSansGujarati.ttf').readAsBytesSync().buffer.asByteData()),
      devanagari: pw.Font.ttf(File('assets/fonts/NotoSansDevanagari.ttf').readAsBytesSync().buffer.asByteData()),
    );
    final s = PdfStrings(
      samaj: 'Samaj',
      wordmarkTop: 'શ્રી મચ્છુકાઠિયા',
      wordmarkBottom: 'SAI SUTHAR SAMAJ',
      title: 'Family tree of Root Solanki',
      footer: 'Generated on {date}',
      page: (p, t) => 'Page $p of $t',
      born: (d) => 'b. $d',
      died: (d) => 'd. $d',
      gotra: 'Gotra',
      village: 'Village',
    );
    final bytes = await buildTreePdf(layout: PdfTreeLayout.build(bigTree()), s: s, fonts: fonts, now: DateTime(2026, 9, 25));
    expect(bytes.length, greaterThan(20000));
    final text = String.fromCharCodes(bytes.take(2000));
    expect(text.startsWith('%PDF'), isTrue);
    final pages = RegExp(r'/Type\s*/Page[^s]').allMatches(String.fromCharCodes(bytes)).length;
    expect(pages, greaterThan(1)); // 243 great-great-great-grandchildren need more than one page
    File('build/tree-sample.pdf')
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);
  });
}
