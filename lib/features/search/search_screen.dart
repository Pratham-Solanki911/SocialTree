import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/names.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';

/// Finds people by name in either script. Results show "son of / daughter of"
/// and are grouped by family when there are many.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery});
  final String? initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _c = TextEditingController(text: widget.initialQuery ?? '');
  String _q = '';
  bool _onlyAncestors = false;
  List<Person> _results = const [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if ((widget.initialQuery ?? '').trim().isNotEmpty) WidgetsBinding.instance.addPostFrameCallback((_) => _run(widget.initialQuery!));
  }

  @override
  void didUpdateWidget(SearchScreen old) {
    super.didUpdateWidget(old);
    if (widget.initialQuery != old.initialQuery && (widget.initialQuery ?? '').isNotEmpty) {
      _c.text = widget.initialQuery!;
      _run(widget.initialQuery!);
    }
  }

  Future<void> _run(String q) async {
    _q = q;
    if (q.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    setState(() => _busy = true);
    try {
      final r = await ref.read(reposProvider).search(q);
      if (mounted && _q == q) setState(() => _results = r);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final me = ref.watch(myPersonProvider).value;
    final ancestors = me == null || !_onlyAncestors ? null : ref.watch(ancestorIdsProvider(me.id)).value;
    final shown = ancestors == null ? _results : _results.where((p) => ancestors.contains(p.id)).toList();
    // Group by family once the list is long enough to need it.
    final groups = <String, List<Person>>{};
    for (final p in shown) {
      groups.putIfAbsent(p.familyId, () => []).add(p);
    }
    final grouped = shown.length > 8 && groups.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _c,
          autofocus: widget.initialQuery == null,
          decoration: InputDecoration(hintText: l.searchByName, border: InputBorder.none, prefixIcon: const Icon(Icons.search)),
          onChanged: _run,
          textInputAction: TextInputAction.search,
        ),
      ),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          if (me != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(children: [
                FilterChip(label: Text(l.onlyMyAncestors), avatar: const Icon(Icons.arrow_upward, size: 16), selected: _onlyAncestors, onSelected: (v) => setState(() => _onlyAncestors = v)),
              ]),
            ),
          Expanded(
            child: _q.trim().length < 2
                ? EmptyState(text: l.searchHint, icon: Icons.person_search_outlined)
                : shown.isEmpty
                    ? EmptyState(text: l.noResults, icon: Icons.search_off)
                    : grouped
                        ? ListView(children: [
                            for (final e in groups.entries) ...[
                              SectionTitle(displayName(context, gu: e.value.first.familyName, en: e.value.first.familyNameEn).oneLine),
                              for (final p in e.value) PersonTile(person: p),
                            ],
                          ])
                        : ListView.builder(itemCount: shown.length, itemBuilder: (_, i) => PersonTile(person: shown[i], showFamily: true)),
          ),
        ],
      ),
    );
  }
}
