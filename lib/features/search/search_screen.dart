import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _q = '';
  bool _onlyAncestors = false;
  List<Person> _results = const [];
  bool _busy = false;

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
    final families = ref.watch(familiesProvider).value ?? const <Family>[];
    final shown = ancestors == null ? _results : _results.where((p) => ancestors.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: l.searchHint, border: InputBorder.none, prefixIcon: const Icon(Icons.search)),
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
              child: Row(
                children: [
                  FilterChip(
                    label: Text(l.onlyMyAncestors),
                    avatar: const Icon(Icons.arrow_upward, size: 16),
                    selected: _onlyAncestors,
                    onSelected: (v) => setState(() => _onlyAncestors = v),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _q.trim().length < 2
                ? EmptyState(text: l.searchHint, icon: Icons.person_search_outlined)
                : shown.isEmpty
                    ? EmptyState(text: l.noResults, icon: Icons.search_off)
                    : ListView.builder(
                        itemCount: shown.length,
                        itemBuilder: (_, i) {
                          final p = shown[i];
                          final fam = families.where((f) => f.id == p.familyId).firstOrNull;
                          return PersonTile(
                            person: p,
                            subtitle: [lifespan(context, p), if (fam != null) fam.name, if (p.nativeVillage != null) p.nativeVillage!].where((s) => s.isNotEmpty).join(' · '),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
