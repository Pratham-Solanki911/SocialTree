import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Keeps the free 1 GB storage bucket usable: every image is re-encoded as JPEG
/// with EXIF stripped and quality lowered until it fits the byte budget.
class ImageCompressor {
  /// Passport photo: ~3:4 portrait, at most 480x640, target <= 100 KB.
  static Future<Uint8List> passport(Uint8List src) =>
      _shrink(src, maxW: 480, maxH: 640, targetBytes: 100 * 1024, minQuality: 40);

  /// Album / profile media: at most 1600 px, target <= 300 KB.
  static Future<Uint8List> photo(Uint8List src) =>
      _shrink(src, maxW: 1600, maxH: 1600, targetBytes: 300 * 1024, minQuality: 50);

  static Future<Uint8List> _shrink(
    Uint8List src, {
    required int maxW,
    required int maxH,
    required int targetBytes,
    required int minQuality,
  }) async {
    var quality = 85;
    Uint8List out = src;
    // mytail: at most 4 re-encodes (85,70,55,40). Good enough for phone camera
    // output; if a source ever stays above budget, add a second downscale pass.
    while (true) {
      out = await FlutterImageCompress.compressWithList(
        src,
        minWidth: maxW,
        minHeight: maxH,
        quality: quality,
        format: CompressFormat.jpeg,
        keepExif: false,
      );
      if (out.length <= targetBytes || quality <= minQuality) return out;
      quality -= 15;
    }
  }

  static String humanSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
