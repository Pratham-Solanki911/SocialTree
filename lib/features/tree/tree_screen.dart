import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';

/// Three views over the same subgraph: layered graph, pedigree chart, and a
/// descendants outline.
class TreeScreen extends ConsumerStatefulWidget {
  const TreeScreen({super.key, required this.rootId});
  final String rootId;

  @override
  ConsumerState<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends ConsumerState<TreeScreen> {
  int _hops = 4;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final tree = ref.watch(treeProvider((widget.rootId, _hops)));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tree.value?[widget.rootId]?.shortName ?? l.familyTree),
          actions: [
            PopupMenuButton<int>(
              tooltip: l.generations,
              icon: const Icon(Icons.unfold_more),
              initialValue: _hops,
              onSelected: (v) => setState(() => _hops = v),
              itemBuilder: (_) => [for (final n in [2, 3, 4, 5, 6, 8]) PopupMenuItem(value: n, child: Text(l.generationsHint(n)))],
            ),
          ],
          bottom: TabBar(tabs: [Tab(text: l.treeGraph), Tab(text: l.ancestors), Tab(text: l.descendants)]),
        ),
        body: AsyncBody<TreeData>(
          value: tree,
          onRetry: () => ref.invalidate(treeProvider((widget.rootId, _hops))),
          builder: (t) => TabBarView(
            children: [
              _GraphView(tree: t, rootId: widget.rootId),
              _PedigreeView(tree: t, rootId: widget.rootId, maxDepth: _hops),
              _DescendantsView(tree: t, rootId: widget.rootId),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraphView extends StatelessWidget {
  const _GraphView({required this.tree, required this.rootId});
  final TreeData tree;
  final String rootId;

  @override
  Widget build(BuildContext context) {
    final graph = Graph()..isTree = false;
    for (final id in tree.persons.keys) {
      graph.addNode(Node.Id(id));
    }
    for (final (parent, child) in tree.parentEdges) {
      graph.addEdge(Node.Id(parent), Node.Id(child));
    }
    // mytail: spouse edges are not drawn (Sugiyama layers directed edges);
    // spouses are listed on each card instead. Switch to a couple-node layout
    // if the samaj asks for marriage lines.
    final config = SugiyamaConfiguration()
      ..nodeSeparation = 24
      ..levelSeparation = 48
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
    final edgeColor = Theme.of(context).colorScheme.outline;
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(600),
      minScale: 0.05,
      maxScale: 3,
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: GraphView(
          graph: graph,
          algorithm: SugiyamaAlgorithm(config),
          paint: Paint()
            ..color = edgeColor
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke,
          builder: (node) {
            final id = node.key!.value as String;
            final p = tree[id]!;
            return _NodeCard(person: p, spouses: tree.spousesOf(id), isRoot: id == rootId);
          },
        ),
      ),
    );
  }
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({required this.person, required this.spouses, required this.isRoot});
  final Person person;
  final List<Person> spouses;
  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.push('/persons/${person.id}'),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRoot ? scheme.primaryContainer : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: person.gender == 'female' ? Colors.pink.shade200 : Colors.blue.shade200, width: 1.5),
        ),
        child: Row(
          children: [
            PersonAvatar(path: person.passportPhotoPath, initials: person.initials, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(person.shortName, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelLarge),
                  Text(lifespan(context, person), style: Theme.of(context).textTheme.labelSmall),
                  if (spouses.isNotEmpty)
                    Text('⚭ ${spouses.map((s) => s.firstName).join(', ')}', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
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
    final father = tree.fatherOf(person.id);
    final mother = tree.motherOf(person.id);
    final parents = [father, mother].whereType<Person>().toList();
    final card = SizedBox(
      width: 170,
      child: Card(
        child: ListTile(
          dense: true,
          leading: PersonAvatar(path: person.passportPhotoPath, initials: person.initials, size: 28),
          title: Text(person.shortName, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(lifespan(context, person)),
          onTap: () => context.push('/persons/${person.id}'),
        ),
      ),
    );
    if (parents.isEmpty || depth >= maxDepth) return card;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        card,
        const SizedBox(width: 12, child: Divider(thickness: 1.5)),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final p in parents) Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: _PedigreeNode(tree: tree, person: p, depth: depth + 1, maxDepth: maxDepth)),
          ],
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
            child: PersonTile(person: p, subtitle: [lifespan(context, p), '⚭ ${tree.spousesOf(p.id).map((s) => s.firstName).join(', ')}'].where((s) => s.length > 2).join(' · ')),
          ),
      ],
    );
  }
}
