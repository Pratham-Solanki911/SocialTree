import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';

import '../../core/l10n_ext.dart';
import '../../core/names.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';
import 'tree_pdf.dart';

/// A focused view: the person in the middle with two generations around them.
/// Tap someone to move the focus to them; hold to open their page. A search
/// box jumps to anyone in the loaded tree. Three views share the data.
class TreeScreen extends ConsumerStatefulWidget {
  const TreeScreen({super.key, required this.rootId});
  final String rootId;

  @override
  ConsumerState<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends ConsumerState<TreeScreen> {
  late String _root = widget.rootId;
  int _hops = 2;
  String? _highlight;
  final _transform = TransformationController();
  final _viewKey = GlobalKey();

  void _focus(String id) => setState(() {
        _root = id;
        _highlight = id;
        _transform.value = Matrix4.identity();
      });

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final tree = ref.watch(treeProvider((_root, _hops)));
    final rootPerson = tree.value?[_root];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: rootPerson == null ? Text(l.familyTree) : NameText(personShortName(context, rootPerson), maxLines: 1),
          actions: [
            if (rootPerson != null)
              IconButton(icon: const Icon(Icons.picture_as_pdf_outlined), tooltip: l.downloadTreePdf, onPressed: () => downloadTreePdf(context, ref, rootPerson)),
            PopupMenuButton<int>(
              tooltip: l.generations,
              icon: const Icon(Icons.unfold_more),
              initialValue: _hops,
              onSelected: (v) => setState(() => _hops = v),
              itemBuilder: (_) => [for (final n in [1, 2, 3, 4, 6]) PopupMenuItem(value: n, child: Text(l.generationsHint(n)))],
            ),
          ],
          bottom: TabBar(tabs: [Tab(text: l.treeGraph), Tab(text: l.ancestors), Tab(text: l.descendants)]),
        ),
        body: AsyncBody<TreeData>(
          value: tree,
          onRetry: () => ref.invalidate(treeProvider((_root, _hops))),
          builder: (t) => Column(
            children: [
              _TreeSearch(tree: t, onPick: _focus),
              Expanded(
                child: TabBarView(
                  children: [
                    _GraphView(key: _viewKey, tree: t, rootId: _root, highlight: _highlight, transform: _transform, onFocus: _focus),
                    _PedigreeView(tree: t, rootId: _root, maxDepth: _hops),
                    _DescendantsView(tree: t, rootId: _root),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TreeSearch extends StatefulWidget {
  const _TreeSearch({required this.tree, required this.onPick});
  final TreeData tree;
  final ValueChanged<String> onPick;

  @override
  State<_TreeSearch> createState() => _TreeSearchState();
}

class _TreeSearchState extends State<_TreeSearch> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final q = _q.trim().toLowerCase();
    final hits = q.length < 2
        ? const <Person>[]
        : widget.tree.persons.values.where((p) => '${p.fullName} ${p.fullNameEn ?? ''} ${p.nickname ?? ''}'.toLowerCase().contains(q)).take(6).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: TextField(
            decoration: InputDecoration(labelText: l.findInTree, prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder(), isDense: true),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        for (final p in hits)
          ListTile(
            dense: true,
            leading: const Icon(Icons.center_focus_strong_outlined),
            title: NameText(personName(context, p), maxLines: 1),
            subtitle: Text(lifespan(context, p)),
            onTap: () {
              setState(() => _q = '');
              widget.onPick(p.id);
            },
          ),
        if (q.length < 2) Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 0), child: Text(l.treeHint, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}

class _GraphView extends StatelessWidget {
  const _GraphView({super.key, required this.tree, required this.rootId, required this.highlight, required this.transform, required this.onFocus});
  final TreeData tree;
  final String rootId;
  final String? highlight;
  final TransformationController transform;
  final ValueChanged<String> onFocus;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final graph = Graph()..isTree = false;
    final gens = tree.generationsFrom(rootId);
    for (final id in tree.persons.keys) {
      graph.addNode(Node.Id(id));
    }
    for (final (parent, child) in tree.parentEdges) {
      graph.addEdge(Node.Id(parent), Node.Id(child));
    }
    // mytail: spouse edges are not drawn (Sugiyama layers directed edges);
    // spouses are named on each card. Couples-as-one-node would be the upgrade.
    final config = SugiyamaConfiguration()
      ..nodeSeparation = 32
      ..levelSeparation = 72
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: transform,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(800),
          minScale: 0.05,
          maxScale: 3,
          child: Padding(
            padding: const EdgeInsets.all(64),
            child: GraphView(
              graph: graph,
              algorithm: SugiyamaAlgorithm(config),
              paint: Paint()
                ..color = scheme.outline
                ..strokeWidth = 1.5
                ..style = PaintingStyle.stroke,
              builder: (node) {
                final id = node.key!.value as String;
                final p = tree[id]!;
                return _NodeCard(
                  person: p,
                  spouses: tree.spousesOf(id),
                  isRoot: id == rootId,
                  isHighlighted: id == highlight,
                  generation: gens[id] ?? 0,
                  onTap: () => onFocus(id),
                  onLongPress: () => context.push('/persons/$id'),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: FilledButton.tonalIcon(
            onPressed: () => transform.value = Matrix4.identity(),
            icon: const Icon(Icons.fit_screen_outlined),
            label: Text(l.fitToScreen),
          ),
        ),
      ],
    );
  }
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({required this.person, required this.spouses, required this.isRoot, required this.isHighlighted, required this.generation, required this.onTap, required this.onLongPress});
  final Person person;
  final List<Person> spouses;
  final bool isRoot;
  final bool isHighlighted;
  final int generation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Older generations fade slightly so the eye lands on the focus row.
    final tint = switch (generation) { < 0 => scheme.surfaceContainerHigh, 0 => scheme.surfaceContainerHighest, _ => scheme.surfaceContainer };
    final border = isHighlighted ? scheme.primary : person.gender == 'female' ? Colors.pink.shade300 : Colors.blue.shade300;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRoot ? scheme.primaryContainer : tint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: isHighlighted || isRoot ? 3 : 1.5),
          boxShadow: isRoot ? [BoxShadow(color: scheme.shadow.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
        child: Row(
          children: [
            PersonAvatar(path: person.passportPhotoPath, initials: person.initials, size: 32),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  NameText(personShortName(context, person), style: Theme.of(context).textTheme.labelLarge),
                  Text(lifespan(context, person), style: Theme.of(context).textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (spouses.isNotEmpty)
                    Text('⚭ ${spouses.map((s) => displayName(context, gu: s.firstName, en: s.firstNameEn).primary).join(', ')}',
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Root on the left, father above mother to the right, recursively.
class _PedigreeView extends StatelessWidget {
  const _PedigreeView({required this.tree, required this.rootId, required this.maxDepth});
  final TreeData tree;
  final String rootId;
  final int maxDepth;

  @override
  Widget build(BuildContext context) {
    final root = tree[rootId];
    if (root == null) return EmptyState(text: context.l.noRelatives);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: _PedigreeNode(tree: tree, person: root, depth: 0, maxDepth: maxDepth),
      ),
    );
  }
}

class _PedigreeNode extends StatelessWidget {
  const _PedigreeNode({required this.tree, required this.person, required this.depth, required this.maxDepth});
  final TreeData tree;
  final Person person;
  final int depth;
  final int maxDepth;

  @override
  Widget build(BuildContext context) {
    final parents = [tree.fatherOf(person.id), tree.motherOf(person.id)].whereType<Person>().toList();
    final card = SizedBox(
      width: 190,
      child: Card(
        child: ListTile(
          dense: true,
          leading: PersonAvatar(path: person.passportPhotoPath, initials: person.initials, size: 28),
          title: NameText(personShortName(context, person)),
          subtitle: Text(lifespan(context, person)),
          onTap: () => context.push('/persons/${person.id}'),
        ),
      ),
    );
    if (parents.isEmpty || depth >= maxDepth) return card;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        card,
        const SizedBox(width: 12, child: Divider(thickness: 1.5)),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final p in parents) Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: _PedigreeNode(tree: tree, person: p, depth: depth + 1, maxDepth: maxDepth))],
        ),
      ],
    );
  }
}

class _DescendantsView extends StatelessWidget {
  const _DescendantsView({required this.tree, required this.rootId});
  final TreeData tree;
  final String rootId;

  @override
  Widget build(BuildContext context) {
    final root = tree[rootId];
    if (root == null) return EmptyState(text: context.l.noRelatives);
    final rows = tree.descendantsOf(rootId);
    return ListView(
      children: [
        PersonTile(person: root),
        if (rows.isEmpty) EmptyState(text: context.l.noRelatives, icon: Icons.account_tree_outlined),
        for (final (p, depth) in rows)
          Padding(
            padding: EdgeInsets.only(left: 20.0 * depth),
            child: PersonTile(
              person: p,
              subtitle: [lifespan(context, p), if (tree.spousesOf(p.id).isNotEmpty) '⚭ ${tree.spousesOf(p.id).map((s) => displayName(context, gu: s.firstName, en: s.firstNameEn).primary).join(', ')}']
                  .where((s) => s.isNotEmpty)
                  .join(' · '),
            ),
          ),
      ],
    );
  }
}
