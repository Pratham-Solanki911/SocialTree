import '../../models/models.dart';

/// A person placed on the printable tree, in unscaled layout units.
class PdfNode {
  PdfNode({required this.person, required this.gen, required this.gotraName, required this.familyName});
  final Person person;
  final int gen;
  final String? gotraName;
  final String? familyName;
  double x = 0; // left edge of the card
  double y = 0; // top edge of the card
}

/// Rows of couples ordered under their parents, plus the edges to draw.
/// Pure Dart so it is unit-testable; the renderer only draws it.
class PdfTreeLayout {
  PdfTreeLayout._(this.nodes, this.rows, this.parentEdges, this.spouseEdges, this.width, this.height);

  static const cardW = 150.0;
  static const cardH = 58.0;
  static const hGap = 14.0; // between cards in a couple / between couples
  static const vGap = 70.0;

  final Map<String, PdfNode> nodes;
  final List<List<PdfNode>> rows; // top row = oldest generation
  final List<(String, String)> parentEdges;
  final List<(String, String)> spouseEdges;
  final double width;
  final double height;

  static PdfTreeLayout build(Map<String, dynamic> data) {
    final rootId = data['root'] as String;
    final nodes = <String, PdfNode>{};
    for (final raw in (data['persons'] as List)) {
      final m = Map<String, dynamic>.from(raw as Map);
      nodes[m['id'] as String] = PdfNode(
        person: Person.fromMap(m),
        gen: (m['gen'] as num).toInt(),
        gotraName: m['gotra_name'] as String?,
        familyName: m['family_name'] as String?,
      );
    }
    final rels = (data['relationships'] as List).map((e) => Relationship.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    final parents = <String, List<String>>{};
    final children = <String, List<String>>{};
    final spouses = <String, List<String>>{};
    final parentEdges = <(String, String)>[];
    final spouseEdges = <(String, String)>[];
    for (final r in rels) {
      if (!nodes.containsKey(r.personId) || !nodes.containsKey(r.relatedId)) continue;
      if (r.kind == 'parent') {
        parents.putIfAbsent(r.relatedId, () => []).add(r.personId);
        children.putIfAbsent(r.personId, () => []).add(r.relatedId);
        parentEdges.add((r.personId, r.relatedId));
      } else {
        spouses.putIfAbsent(r.personId, () => []).add(r.relatedId);
        spouses.putIfAbsent(r.relatedId, () => []).add(r.personId);
        spouseEdges.add((r.personId, r.relatedId));
      }
    }

    // Group each generation into couples (a person followed by spouses on the same row).
    final gens = nodes.values.map((n) => n.gen).toSet().toList()..sort();
    final rowsByGen = <int, List<List<PdfNode>>>{};
    for (final g in gens) {
      final members = nodes.values.where((n) => n.gen == g).toList()
        ..sort((a, b) => (a.person.dob ?? DateTime(2100)).compareTo(b.person.dob ?? DateTime(2100)));
      final used = <String>{};
      final couples = <List<PdfNode>>[];
      for (final n in members) {
        if (used.contains(n.person.id)) continue;
        final unit = [n];
        used.add(n.person.id);
        for (final s in spouses[n.person.id] ?? const <String>[]) {
          final sn = nodes[s];
          if (sn != null && sn.gen == g && used.add(s)) unit.add(sn);
        }
        couples.add(unit);
      }
      rowsByGen[g] = couples;
    }

    // Order couples: root generation first (root in the middle of its siblings),
    // younger rows follow their parents' order, older rows follow their children's.
    double anchor(List<PdfNode> unit, Map<String, double> ref, Map<String, List<String>> via) {
      final xs = <double>[];
      for (final n in unit) {
        for (final id in via[n.person.id] ?? const <String>[]) {
          final x = ref[id];
          if (x != null) xs.add(x);
        }
      }
      return xs.isEmpty ? double.infinity : xs.reduce((a, b) => a + b) / xs.length;
    }

    final centerX = <String, double>{};
    void place(List<List<PdfNode>> couples) {
      var x = 0.0;
      for (final unit in couples) {
        for (final n in unit) {
          n.x = x;
          centerX[n.person.id] = x + cardW / 2;
          x += cardW + hGap;
        }
        x += hGap;
      }
    }

    final rootGen = nodes[rootId]?.gen ?? 0;
    final rootRow = rowsByGen[rootGen]!;
    rootRow.sort((a, b) => a.first.person.lastName.compareTo(b.first.person.lastName));
    final ri = rootRow.indexWhere((u) => u.any((n) => n.person.id == rootId));
    if (ri > 0) rootRow.insert(rootRow.length ~/ 2, rootRow.removeAt(ri));
    place(rootRow);
    for (var g = rootGen + 1; g <= gens.last; g++) {
      final row = rowsByGen[g];
      if (row == null) continue;
      final keyed = {for (final u in row) identityHashCode(u): anchor(u, centerX, parents)};
      row.sort((a, b) => keyed[identityHashCode(a)]!.compareTo(keyed[identityHashCode(b)]!));
      place(row);
    }
    for (var g = rootGen - 1; g >= gens.first; g--) {
      final row = rowsByGen[g];
      if (row == null) continue;
      final keyed = {for (final u in row) identityHashCode(u): anchor(u, centerX, children)};
      row.sort((a, b) => keyed[identityHashCode(a)]!.compareTo(keyed[identityHashCode(b)]!));
      place(row);
    }

    // Centre every row on the widest one and assign y by generation.
    final rows = [for (final g in gens) rowsByGen[g]!.expand((u) => u).toList()];
    var width = 0.0;
    for (final row in rows) {
      final w = row.last.x + cardW;
      if (w > width) width = w;
    }
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final w = row.last.x + cardW;
      final shift = (width - w) / 2;
      for (final n in row) {
        n.x += shift;
        n.y = i * (cardH + vGap);
      }
    }
    // mytail: couples are ordered by their parents' average x, siblings sorted
    // by birth date. Crossing lines are possible in large cousin marriages;
    // a Sugiyama pass would fix that if it ever matters on paper.
    final height = rows.length * (cardH + vGap) - vGap;
    return PdfTreeLayout._(nodes, rows, parentEdges, spouseEdges, width, height);
  }
}
