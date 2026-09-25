import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/image_compressor.dart';
import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

const maxUploadBytes = 5 * 1024 * 1024; // matches the bucket limit

/// Photos (compressed uploads), video links and documents for an album or a
/// person, with the upload bar. Exactly one of albumId / personId is set.
class MediaGrid extends ConsumerWidget {
  const MediaGrid({super.key, this.albumId, this.personId, required this.canEdit});
  final String? albumId;
  final String? personId;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final provider = albumId != null ? albumMediaProvider(albumId!) : personMediaProvider(personId!);
    final media = ref.watch(provider);
    final uid = ref.watch(currentUserIdProvider);
    final isAdmin = ref.watch(myProfileProvider).value?.isAdmin ?? false;
    final premium = ref.watch(myProfileProvider).value?.isPremium ?? false;
    final repos = ref.read(reposProvider);

    Future<void> run(Future<void> Function() job) async {
      try {
        await job();
        ref.invalidate(provider);
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }

    Future<void> uploadPhoto(ImageSource src) async {
      final f = await ImagePicker().pickImage(source: src, maxWidth: 2400, maxHeight: 2400);
      if (f == null) return;
      await run(() async {
        final jpeg = await ImageCompressor.photo(await f.readAsBytes());
        await repos.uploadPhoto(albumId: albumId, personId: personId, jpeg: jpeg);
        if (context.mounted) showMessage(context, l.photoCompressedTo(ImageCompressor.humanSize(jpeg.length)));
      });
    }

    Future<void> uploadDoc() async {
      final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: const ['pdf']);
      final f = files.firstOrNull;
      if (f == null) return;
      final bytes = await f.xFile.readAsBytes();
      if (bytes.length > maxUploadBytes) {
        if (context.mounted) showMessage(context, l.fileTooLarge);
        return;
      }
      await run(() => repos.uploadDocument(albumId: albumId, personId: personId, bytes: bytes, filename: f.name, mimeType: 'application/pdf'));
    }

    Future<void> addVideo() async {
      final url = TextEditingController();
      final caption = TextEditingController();
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.addVideoLink),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: url, decoration: InputDecoration(labelText: l.videoUrl), keyboardType: TextInputType.url),
              TextField(controller: caption, decoration: InputDecoration(labelText: l.caption)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, Uri.tryParse(url.text.trim())?.hasAbsolutePath ?? false), child: Text(l.save)),
          ],
        ),
      );
      if (ok != true) return;
      await run(() => repos.addVideoLink(albumId: albumId, personId: personId, url: url.text.trim(), caption: caption.text.trim().isEmpty ? null : caption.text.trim()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canEdit)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(onPressed: () => uploadPhoto(ImageSource.gallery), icon: const Icon(Icons.add_photo_alternate_outlined), label: Text(l.uploadPhoto)),
                FilledButton.tonalIcon(onPressed: () => uploadPhoto(ImageSource.camera), icon: const Icon(Icons.photo_camera_outlined), label: Text(l.takePhoto)),
                FilledButton.tonalIcon(
                  onPressed: premium ? addVideo : null,
                  icon: Icon(premium ? Icons.video_library_outlined : Icons.lock_outline),
                  label: Text(l.addVideoLink),
                ),
                FilledButton.tonalIcon(
                  onPressed: premium ? uploadDoc : null,
                  icon: Icon(premium ? Icons.picture_as_pdf_outlined : Icons.lock_outline),
                  label: Text(l.uploadDocument),
                ),
              ],
            ),
          ),
        if (canEdit && !premium)
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('${l.premiumOnly}: ${l.video}, ${l.document}', style: Theme.of(context).textTheme.bodySmall)),
        AsyncBody<List<MediaItem>>(
          value: media,
          onRetry: () => ref.invalidate(provider),
          builder: (items) => items.isEmpty
              ? EmptyState(text: l.noMedia, icon: Icons.photo_library_outlined)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, mainAxisSpacing: 6, crossAxisSpacing: 6),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final m = items[i];
                    final mine = m.uploadedBy == uid || isAdmin;
                    return GestureDetector(
                      onTap: () => _open(context, ref, m),
                      onLongPress: mine
                          ? () async {
                              if (await confirm(context, l.confirmDelete)) await run(() => repos.deleteMedia(m));
                            }
                          : null,
                      child: _Thumb(m: m),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, MediaItem m) async {
    if (m.externalUrl != null) {
      await launchUrl(Uri.parse(m.externalUrl!), mode: LaunchMode.externalApplication);
      return;
    }
    if (m.kind == 'document') {
      final url = await ref.read(reposProvider).signedUrl(m.storagePath!);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return;
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog.fullscreen(
        child: Stack(
          children: [
            Center(child: InteractiveViewer(child: SignedImage(m.storagePath!, fit: BoxFit.contain))),
            if (m.caption != null)
              Positioned(left: 16, right: 16, bottom: 24, child: Text(m.caption!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 4)]))),
            Positioned(top: 8, right: 8, child: SafeArea(child: IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)))),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.m});
  final MediaItem m;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (m.kind) { 'video' => Icons.play_circle_outline, 'document' => Icons.picture_as_pdf_outlined, _ => Icons.image_outlined };
    return Container(
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: m.kind == 'photo' && m.storagePath != null
          ? SignedImage(m.storagePath!)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(m.caption ?? (m.kind == 'video' ? context.l.video : context.l.document), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
                ),
              ],
            ),
    );
  }
}
