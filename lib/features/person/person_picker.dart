import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import 'person_tile.dart';

/// Full-screen search that returns the chosen person.
Future<Person?> pickPerson(BuildContext context, {Set<String> exclude = const {}}) =>
    Navigator.of(context, rootNavigator: true).push<Person>(MaterialPageRoute(builder: (_) => _PickerScreen(exclude: exclude)));

class _PickerScreen extends ConsumerStatefulWidget {
  const _PickerScreen({required this.exclude});
  final Set<String> exclude;

  @override
  ConsumerState<_PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends ConsumerState<_PickerScreen> {
  String _q = '';
  List<Person> _results = const [];
  bool _busy = false;

  Future<void> _search(String q) async {
    _q = q;
    if (q.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    setState(() => _busy = true);
    try {
      final r = await ref.read(reposProvider).search(q);
      if (mounted && _q == q) setState(() => _results = r.where((p) => !widget.exclude.contains(p.id)).toList());
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final recent = ref.watch(recentPersonsProvider).value ?? const <Person>[];
    final list = _q.trim().length < 2 ? recent.where((p) => !widget.exclude.contains(p.id)).toList() : _results;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: l.searchHint, border: InputBorder.none),
          onChanged: _search,
        ),
      ),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          if (_q.trim().length < 2) SectionTitle(l.recentlyAdded),
          Expanded(
            child: list.isEmpty
                ? EmptyState(text: l.noResults, icon: Icons.search_off)
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => PersonTile(person: list[i], onTap: () => Navigator.pop(context, list[i])),
                  ),
          ),
        ],
      ),
    );
  }
}
