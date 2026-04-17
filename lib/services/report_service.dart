/// ===============================
/// FILE: lib/services/report_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'ban_service.dart'; 

class ReportService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> reportReel(String reelId, String reason, String authorId) async {
    // 1. Save the report to Firestore
    await _db.collection("reports").add({
      "type": "reel",
      "id": reelId,
      "reason": reason,
      "time": FieldValue.serverTimestamp(),
    });

    // 2. Add strike to the author of the reel
    await BanService.addStrike(authorId);
  }

  static Future<void> reportUser(String userId, String reason) async {
    // 1. Save the user report
    await _db.collection("reports").add({
      "type": "user",
      "id": userId,
      "reason": reason,
      "time": FieldValue.serverTimestamp(),
    });

    // 2. Add strike directly to the reported user
    await BanService.addStrike(userId);
  }
}