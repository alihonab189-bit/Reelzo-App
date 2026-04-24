import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

class MediaCompressService {

  /// ================= IMAGE COMPRESS =================
  static Future<File?> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      "${file.path}_compressed.jpg",
      quality: 70, // 0-100 (70 best balance)
    );

    return result != null ? File(result.path) : null;
  }

  /// ================= VIDEO COMPRESS =================
  static Future<File?> compressVideo(File file) async {
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );

    return info?.file;
  }

  /// ================= CLEAR CACHE =================
  static Future<void> clearCache() async {
    await VideoCompress.deleteAllCache();
  }
}