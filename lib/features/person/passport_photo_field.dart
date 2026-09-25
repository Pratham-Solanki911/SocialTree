import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/image_compressor.dart';
import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';

/// Picks a passport photo, compresses it on-device and hands the JPEG bytes
/// back. `removed` is set when the user clears an existing photo.
class PassportPhotoField extends StatefulWidget {
  const PassportPhotoField({super.key, required this.existingPath, required this.onChanged});
  final String? existingPath;
  final void Function({Uint8List? bytes, bool removed}) onChanged;

  @override
  State<PassportPhotoField> createState() => _PassportPhotoFieldState();
}

class _PassportPhotoFieldState extends State<PassportPhotoField> {
  Uint8List? _bytes;
  bool _removed = false;
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, maxWidth: 1600, maxHeight: 1600);
    if (file == null) return;
    setState(() => _busy = true);
    try {
      final raw = await file.readAsBytes();
      final jpeg = await ImageCompressor.passport(raw);
      setState(() {
        _bytes = jpeg;
        _removed = false;
      });
      widget.onChanged(bytes: jpeg, removed: false);
      if (mounted) showMessage(context, context.l.photoCompressedTo(ImageCompressor.humanSize(jpeg.length)));
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final hasPhoto = _bytes != null || (widget.existingPath != null && !_removed);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          height: 128,
          child: _busy
              ? const Center(child: CircularProgressIndicator())
              : _bytes != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.memory(_bytes!, fit: BoxFit.cover))
                  : (widget.existingPath != null && !_removed)
                      ? SignedImage(widget.existingPath!, width: 96, height: 128, borderRadius: BorderRadius.circular(6))
                      : Container(
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.portrait_outlined, size: 40),
                        ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.passportPhoto, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(onPressed: _busy ? null : () => _pick(ImageSource.camera), icon: const Icon(Icons.photo_camera_outlined), label: Text(l.takePhoto)),
                  OutlinedButton.icon(onPressed: _busy ? null : () => _pick(ImageSource.gallery), icon: const Icon(Icons.photo_outlined), label: Text(l.chooseFromGallery)),
                  if (hasPhoto)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _bytes = null;
                          _removed = true;
                        });
                        widget.onChanged(bytes: null, removed: true);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l.removePhoto),
                    ),
                ],
              ),
              if (_bytes != null) Text(l.photoCompressedTo(ImageCompressor.humanSize(_bytes!.length)), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
