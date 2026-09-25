import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final albums = ref.watch(albumsProvider);
    final families = ref.watch(familiesProvider).value ?? const <Family>[];
    final premium = ref.watch(myProfileProvider).value?.isPremium ?? false;
    return Scaffold(
      appBar: AppBar(title: Text(l.albums)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref, families),
        icon: const Icon(Icons.add),
        label: Text(l.newAlbum),
      ),
      body: AsyncBody<List<Album>>(
        value: albums,
        onRetry: () => ref.invalidate(albumsProvider),
        builder: (list) => ListView(
          children: [
            if (!premium) Padding(padding: const EdgeInsets.all(16), child: Text(l.freePlanAlbumLimit, style: Theme.of(context).textTheme.bodySmall)),
            if (list.isEmpty) EmptyState(text: l.noMedia, icon: Icons.photo_library_outlined),
            for (final a in list)
              ListTile(
                leading: const Icon(Icons.photo_album_outlined),
                title: Text(a.title),
                subtitle: Text([
                  if (a.familyId != null) families.where((f) => f.id == a.familyId).firstOrNull?.name ?? '',
                  if (a.description != null) a.description!,
                ].where((s) => s.isNotEmpty).join(' · ')),
                onTap: () => context.push('/albums/${a.id}'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref, List<Family> families) async {
    final l = context.l;
    final title = TextEditingController();
    final desc = TextEditingController();
    String? familyId;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.newAlbum),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: title, decoration: InputDecoration(labelText: l.albumTitle), autofocus: true),
              TextField(controller: desc, decoration: InputDecoration(labelText: l.description)),
              DropdownButtonFormField<String?>(
                initialValue: familyId,
                decoration: InputDecoration(labelText: l.family),
                items: [
                  DropdownMenuItem<String?>(value: null, child: Text(l.none)),
                  for (final f in families) DropdownMenuItem<String?>(value: f.id, child: Text(f.name)),
                ],
                onChanged: (v) => setState(() => familyId = v),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, title.text.trim().isNotEmpty), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      final a = await ref.read(reposProvider).createAlbum({
        'title': title.text.trim(),
        'description': desc.text.trim().isEmpty ? null : desc.text.trim(),
        'family_id': familyId,
      });
      ref.invalidate(albumsProvider);
      if (context.mounted) context.push('/albums/${a.id}');
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }
}
