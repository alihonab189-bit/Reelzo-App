import 'package:cloud_firestore/cloud_firestore.dart';

/// 🧠 Unified AI Engine: The Central Brain of Reelzo-App
/// Handles Personalization, Moderation, Boosting, and Analytics
class UnifiedAIEngine {
  static final _db = FirebaseFirestore.instance;

  /// ⭐ VIRAL POTENTIAL ALGORITHM
  static double calculateViralScore(Map<String, dynamic> data) {
    int likes = data["likes"] ?? 0;
    int comments = data["comments"] ?? 0;
    int shares = data["shares"] ?? 0;
    int views = data["views"] ?? 0;

    // Advanced weightage for virality
    return (likes * 1.5) + (comments * 2.5) + (shares * 4.0) + (views * 0.2);
  }

  /// 🎯 PERSONALIZED SMART FEED (High Performance)
  static Future<List<QueryDocumentSnapshot>> getSmartFeed() async {
    var snap = await _db.collection("reels")
        .where("isDeleted", isEqualTo: false)
        .orderBy("viralScore", descending: true)
        .limit(50) 
        .get();

    return snap.docs;
  }

  /// 🛡️ SPAM & SECURITY DETECTION
  static bool hasSecurityViolation(String text) {
    final List<String> restrictedPatterns = [
      "spam", "hack", "fraud", "free money", "http", "click here", "win prize"
    ];
    
    final lowerText = text.toLowerCase();
    return restrictedPatterns.any((pattern) => lowerText.contains(pattern));
  }

  /// 🚫 AUTO BAN SYSTEM
  static Future<void> autoBan(String userId, String reason) async {
    await _db.collection("users").doc(userId).update({
      "isBanned": true,
      "banReason": reason,
      "restrictedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 💰 EARNING OPTIMIZATION TIPS
  static String getEarningTip(Map<String, dynamic> data) {
    int views = data["views"] ?? 0;
    if (views > 1000) return "Unlock Monetization: Enable ads 💰";
    return "Keep creating! Reach 1k views for ads 🔥";
  }

  /// 🤖 MAIN CONTROL UNIT (Called from Upload Screen)
  /// হোনাব ভাই, আপনার এরর ফিক্স করার জন্য মেথডটির নাম 'run' রাখা হয়েছে।
  static Future<void> run({
    required String userId,
    required String postId,
    required String text,
    required Map<String, dynamic> data,
  }) async {
    
    // 1. Security Check
    if (hasSecurityViolation(text)) {
      await autoBan(userId, "Spam detected in caption");
      return;
    }

    // 2. Behavioral Learning
    await _db.collection("ai_intelligence").add({
      "userId": userId,
      "postId": postId,
      "action": "content_audit",
      "timestamp": FieldValue.serverTimestamp(),
    });

    // 3. Initial Score Sync
    double initialScore = calculateViralScore(data);
    await _db.collection("reels").doc(postId).set({
      "viralScore": initialScore,
    }, SetOptions(merge: true));
  }
}