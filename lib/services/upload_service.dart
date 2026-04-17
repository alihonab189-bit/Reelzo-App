/// ===============================
/// FILE: lib/services/upload_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_reel_service.dart'; // Import AI Reel Service

class UploadService {
  static final _db = FirebaseFirestore.instance;

  /// 📤 UPLOAD REEL (Added userId parameter)
  static Future<void> uploadReel({
    required String video, 
    required String caption, 
    required String userId, // Added userId here
  }) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    await _db.collection("reels").doc(id).set({
      "id": id,
      "video": video,
      "caption": caption,
      "userId": userId, // Saving userId to Firestore
      "likes": 0,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🤖 AUTO GENERATE & UPLOAD REEL
  static Future<void> autoUpload(String userId) async { // Added userId parameter here too
    try {
      // 1. Generate content using AI
      var ai = await AIReelService.generateReel(userId);
      String caption = ai["content"] ?? "New Awesome Reel!";

      // 2. Sample or AI Generated Video URL
      String videoUrl = "https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4";

      // 3. Upload to Firestore
      await uploadReel(
        video: videoUrl,
        caption: caption,
        userId: userId, // Passing userId to uploadReel
      );
    } catch (e) {
      print("Auto Upload Error: $e");
    }
  }
}