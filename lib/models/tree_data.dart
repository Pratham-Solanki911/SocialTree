import 'models.dart';

/// In-memory family graph built from `persons` + `relationships` rows.
/// Pure Dart so the tree logic can be unit tested without Flutter.
class TreeData {
  TreeData(Iterable<Person> persons, Iterable<Relationship> relationships)
      : persons = {for (final p in persons) p.id: p},
        relationships = relationships.toList() {
    for (final r in this.relationships) {
      if (r.kind == 'parent') {
        _parents.putIfAbsent(r.relatedId, () => []).add(r.personId);
        _children.putIfAbsent(r.personId, () => []).add(r.relatedId);
      } else {
        _spouses.putIfAbsent(r.personId, () => []).add(r.relatedId);
        _spouses.putIfAbsent(r.relatedId, () => []).add(r.personId);
      }
    }
  }

  final Map<String, Person> persons;
  final List<Relationship> relationships;
  final Map<String, List<String>> _parents = {};
  final Map<String, List<String>> _children = {};
  final Map<String, List<String>> _spouses = {};

  factory TreeData.fromJson(Map<String, dynamic> json) => TreeData(
        ((json['persons'] as List?) ?? const []).map((e) => Person.fromMap(Map<String, dynamic>.from(e as Map))),
        ((json['relationships'] as List?) ?? const []).map((e) => Relationship.fromMap(Map<String, dynamic>.from(e as Map))),
      );

  Person? operator [](String id) => persons[id];
  List<Person> _resolve(Iterable<String> ids) => ids.map((i) => persons[i]).whereType<Person>().toList();

  List<Person> parentsOf(String id) => _resolve(_parents[id] ?? const []);
  List<Person> childrenOf(String id) => _resolve(_children[id] ?? const []);
  List<Person> spousesOf(String id) => _resolve(_spouses[id] ?? const []);

  Person? fatherOf(String id) => parentsOf(id).where((p) => p.gender == 'male').firstOrNull;
  Person? motherOf(String id) => parentsOf(id).where((p) => p.gender == 'female').firstOrNull;

  /// Anyone sharing at least one parent.
  List<Person> siblingsOf(String id) {
    final out = <String>{};
    for (final p in _parents[id] ?? const <String>[]) {
      out.addAll(_children[p] ?? const []);
    }
    out.remove(id);
    return _resolve(out);
  }

  /// Parent -> child edges only (the layered graph view draws these).
  Iterable<(String, String)> get parentEdges =>
      relationships.where((r) => r.kind == 'parent').map((r) => (r.personId, r.relatedId));

  /// Descendants as (person, depth) in depth-first order, for the outline view.
  List<(Person, int)> descendantsOf(String id, {int maxDepth = 12}) {
    final out = <(Person, int)>[];
    final seen = <String>{};
    void walk(String cur, int depth) {
      if (depth > maxDepth) return;
      for (final c in childrenOf(cur)) {
        if (!seen.add(c.id)) continue;
        out.add((c, depth));
        walk(c.id, depth + 1);
      }
    }
    walk(id, 1);
    return out;
  }

  /// Generation index relative to `root` (root = 0, parents = -1, children = 1)
  /// for every reachable person. Spouses share a generation.
  Map<String, int> generationsFrom(String root) {
    final gen = <String, int>{root: 0};
    final queue = [root];
    while (queue.isNotEmpty) {
      final cur = queue.removeAt(0);
      final g = gen[cur]!;
      void visit(String id, int value) {
        if (gen.containsKey(id)) return;
        gen[id] = value;
        queue.add(id);
      }
      for (final p in _parents[cur] ?? const <String>[]) {
        visit(p, g - 1);
      }
      for (final c in _children[cur] ?? const <String>[]) {
        visit(c, g + 1);
      }
      for (final s in _spouses[cur] ?? const <String>[]) {
        visit(s, g);
      }
    }
    return gen;
  }
}
