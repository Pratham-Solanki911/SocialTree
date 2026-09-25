import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import 'media_grid.dart';

class AlbumScreen extends ConsumerWidget {
  const AlbumScreen({super.key, required this.albumId});
  final String albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final album = ref.watch(albumProvider(albumId));
    return Scaffold(
      appBar: AppBar(title: Text(album.value?.title ?? context.l.albums)),
      body: AsyncBody<Album>(
        value: album,
        onRetry: () => ref.invalidate(albumProvider(albumId)),
        builder: (a) => ListView(
          children: [
            if (a.description != null) Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: Text(a.description!)),
            MediaGrid(albumId: albumId, canEdit: true),
          ],
        ),
      ),
    );
  }
}
