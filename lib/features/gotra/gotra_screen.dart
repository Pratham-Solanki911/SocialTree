import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

/// Surname -> gotra -> kuldevi/kuldevta lookup. Everything is editable by
/// members; admins mark entries verified.
class GotraScreen extends ConsumerStatefulWidget {
  const GotraScreen({super.key});

  @override
  ConsumerState<GotraScreen> createState() => _GotraScreenState();
}

class _GotraScreenState extends ConsumerState<GotraScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final gotras = ref.watch(gotrasProvider);
    final lookup = _q.trim().isEmpty ? null : ref.watch(surnameLookupProvider(_q.trim()));
    final isAdmin = ref.watch(myProfileProvider).value?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l.gotraLookup)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editGotra(null),
        icon: const Icon(Icons.add),
        label: Text(l.addGotra),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              decoration: InputDecoration(labelText: l.lookupBySurname, prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder()),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(l.communityContributed, style: Theme.of(context).textTheme.bodySmall),
          ),
          if (lookup != null)
            AsyncBody<List<SurnameGotra>>(
              value: lookup,
              builder: (rows) => Column(
                children: [
                  if (rows.isEmpty) Padding(padding: const EdgeInsets.all(16), child: Text(l.noResults)),
                  for (final r in rows)
                    ListTile(
                      leading: Icon(r.verified ? Icons.verified : Icons.help_outline, color: r.verified ? Colors.green : null),
                      title: Text('${r.surname}${r.village != null ? ' (${r.village})' : ''} → ${r.gotra?.name ?? '?'}'),
                      subtitle: Text([
                        if (r.gotra?.kuldevi != null) '${l.kuldevi}: ${r.gotra!.kuldevi}',
                        if (r.gotra?.kuldevta != null) '${l.kuldevta}: ${r.gotra!.kuldevta}',
                      ].join(' · ')),
                      trailing: isAdmin && !r.verified
                          ? IconButton(
                              icon: const Icon(Icons.verified_outlined),
                              tooltip: l.markVerified,
                              onPressed: () => _patchMapping(r.id, {'verified': true}),
                            )
                          : null,
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(onPressed: _addMapping, icon: const Icon(Icons.add_link), label: Text(l.addMapping)),
          ),
          SectionTitle(l.gotra),
          AsyncBody<List<Gotra>>(
            value: gotras,
            onRetry: () => ref.invalidate(gotrasProvider),
            builder: (list) => Column(
              children: [
                for (final g in list)
                  ListTile(
                    leading: Icon(g.verified ? Icons.verified : Icons.temple_hindu_outlined, color: g.verified ? Colors.green : null),
                    title: Text(g.name),
                    subtitle: Text([
                      if (g.kuldevi != null) '${l.kuldevi}: ${g.kuldevi}',
                      if (g.kuldevta != null) '${l.kuldevta}: ${g.kuldevta}',
                      if (g.notes != null) g.notes!,
                    ].join(' · ')),
                    trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _editGotra(g)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _patchMapping(String id, Map<String, dynamic> m) async {
    try {
      await ref.read(reposProvider).patchSurnameMapping(id, m);
      ref.invalidate(surnameLookupProvider(_q.trim()));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  Future<void> _editGotra(Gotra? g) async {
    final l = context.l;
    final isAdmin = ref.read(myProfileProvider).value?.isAdmin ?? false;
    final name = TextEditingController(text: g?.name);
    final kuldevi = TextEditingController(text: g?.kuldevi);
    final kuldevta = TextEditingController(text: g?.kuldevta);
    final notes = TextEditingController(text: g?.notes);
    var verified = g?.verified ?? false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(g == null ? l.addGotra : l.edit),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: InputDecoration(labelText: l.gotra)),
                TextField(controller: kuldevi, decoration: InputDecoration(labelText: l.kuldevi)),
                TextField(controller: kuldevta, decoration: InputDecoration(labelText: l.kuldevta)),
                TextField(controller: notes, decoration: InputDecoration(labelText: l.notes), maxLines: 2),
                if (isAdmin) SwitchListTile(title: Text(l.verified), value: verified, onChanged: (v) => setState(() => verified = v)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, name.text.trim().isNotEmpty), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    String? nz(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    try {
      await ref.read(reposProvider).saveGotra(g?.id, {
        'name': name.text.trim(),
        'kuldevi': nz(kuldevi),
        'kuldevta': nz(kuldevta),
        'notes': nz(notes),
        'verified': verified,
      });
      ref.invalidate(gotrasProvider);
      if (_q.trim().isNotEmpty) ref.invalidate(surnameLookupProvider(_q.trim()));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  Future<void> _addMapping() async {
    final l = context.l;
    final gotras = ref.read(gotrasProvider).value ?? const <Gotra>[];
    if (gotras.isEmpty) return;
    final surname = TextEditingController(text: _q.trim());
    final village = TextEditingController();
    var gotraId = gotras.first.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.addMapping),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: surname, decoration: InputDecoration(labelText: l.surname)),
              TextField(controller: village, decoration: InputDecoration(labelText: l.village)),
              DropdownButtonFormField<String>(
                initialValue: gotraId,
                decoration: InputDecoration(labelText: l.gotra),
                items: [for (final g in gotras) DropdownMenuItem(value: g.id, child: Text(g.name))],
                onChanged: (v) => setState(() => gotraId = v ?? gotraId),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, surname.text.trim().isNotEmpty), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(reposProvider).addSurnameMapping({
        'surname': surname.text.trim(),
        'village': village.text.trim().isEmpty ? null : village.text.trim(),
        'gotra_id': gotraId,
      });
      setState(() => _q = surname.text.trim());
      ref.invalidate(surnameLookupProvider(_q));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }
}
