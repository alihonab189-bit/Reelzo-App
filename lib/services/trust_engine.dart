import 'package:cloud_firestore/cloud_firestore.dart';

/// 🛡️ TrustEngine: The Safety & Credibility Guard of Reelzo-App
class TrustEngine {
  static final _db = FirebaseFirestore.instance;

  /// ⭐ DYNAMIC TRUST SCORE CALCULATION
  static Future<void> calculateReputation(String userId, int totalLikes, int reportCount) async {
    double score = (totalLikes * 0.2) - (reportCount * 5.0);

    await _db.collection("users").doc(userId).set({
      "trustScore": score,
      "lastAudit": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 📉 CONTENT QUALITY AUDIT
  static bool isSubstandardContent(Map<String, dynamic> data) {
    int views = data["views"] ?? 0;
    int likes = data["likes"] ?? 0;

    if (views > 100 && (likes / views) < 0.02) return true;
    return false;
  }

  /// 🚀 ELITE USER PROMOTION
  static Future<void> promoteTrustedUser(String userId) async {
    var doc = await _db.collection("users").doc(userId).get();
    if (!doc.exists) return;
    
    double trustScore = (doc.data()?["trustScore"] ?? 0).toDouble();

    if (trustScore >= 100) {
      await _db.collection("users").doc(userId).update({
        "isEliteMember": true,
        "globalBoost": true,
        "badge": "Trusted Creator 🛡️",
      });
    }
  }

  /// ⚠️ AUTOMATED ACCOUNT LIMITATION
  static Future<void> enforceLimits(String userId) async {
    await _db.collection("users").doc(userId).update({
      "isShadowBanned": true,
      "reachLimited": true,
      "limitationDate": FieldValue.serverTimestamp(),
    });
  }

  /// 🎁 LOYALTY REWARD SYSTEM
  static Future<void> distributeReward(String userId) async {
    await _db.collection("wallets").doc(userId).set({
      "creatorBonus": FieldValue.increment(50),
      "lastRewardDate": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 🤖 CENTRAL SAFETY PROTOCOL (ALIAS: run)
  /// হোনাব ভাই, আমি মেথডটির নাম 'run' করে দিচ্ছি যাতে আপনার আপলোড স্ক্রিনের এরর চলে যায়।
  static Future<void> run({
    required String userId,
    required Map<String, dynamic> contentData,
    required int likes,
    required int reports,
  }) async {
    
    // 1. Update overall reputation
    await calculateReputation(userId, likes, reports);

    // 2. Audit content quality
    if (isSubstandardContent(contentData)) {
      await enforceLimits(userId);
      return; 
    }

    // 3. Promote if user is exceptionally trustworthy
    await promoteTrustedUser(userId);

    // 4. Milestone-based rewards
    if (likes >= 500) {
      await distributeReward(userId);
    }
  }
}