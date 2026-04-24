import 'package:cloud_firestore/cloud_firestore.dart';

/// 🚀 Advanced AI-Driven Content Control & Optimization Engine
class CoreBrainEngine {
  static final _db = FirebaseFirestore.instance;

  /// 🧠 BEHAVIORAL TRACKING
  /// Logs user interactions for deep data analysis
  static Future<void> trackActivity(String userId, String action, {Map<String, dynamic>? meta}) async {
    await _db.collection("brain_logs").add({
      "userId": userId,
      "action": action,
      "metadata": meta ?? {},
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  /// 🎯 PRECISION RANKING ALGORITHM
  /// Calculates real-time engagement and quality scores
  static double calculateEngagementScore(Map<String, dynamic> stats) {
    int likes = stats["likes"] ?? 0;
    int comments = stats["comments"] ?? 0;
    int shares = stats["shares"] ?? 0;
    double avgWatchTime = (stats["watchTimeAverage"] ?? 0).toDouble();

    // Proprietary Ranking Formula: (Weights optimized for virality)
    return (likes * 1.5) + (comments * 2.5) + (shares * 4.0) + (avgWatchTime * 1.8);
  }

  /// 🛡️ AUTOMATED SAFETY & ANTI-SPAM SYSTEM
  /// Identifies restricted keywords and malicious links
  static bool hasSafetyViolation(String text) {
    final List<String> blackList = [
      "http", "www", ".com", "free cash", "click here", "scam", 
      "spam", "phishing", "fake", "offensiveWord1"
    ];
    
    final lowerText = text.toLowerCase();
    return blackList.any((word) => lowerText.contains(word));
  }

  /// 🚀 AUTONOMOUS CONTENT DISCOVERY (BOOST)
  /// Automatically promotes high-quality content to Trending
  static Future<void> triggerSmartBoost(String postId, double score) async {
    if (score >= 500) {
      await _db.collection("reels").doc(postId).update({
        "isTrending": true,
        "algorithmStatus": score > 1000 ? "Elite Tier" : "Priority Feed",
        "boostTimestamp": FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🤖 MASTER EXECUTION UNIT
  /// This is the primary logic that governs automated decisions
  static Future<void> processAILogic({
    required String userId,
    required String contentText,
    required String postId,
    required Map<String, dynamic> currentStats,
  }) async {
    
    // 1. Behavior Logging
    await trackActivity(userId, "content_publication_trigger", meta: {"postId": postId});

    // 2. Automated Moderation
    if (hasSafetyViolation(contentText)) {
      await _db.collection("users").doc(userId).update({
        "trustScore": FieldValue.increment(-10),
        "accountStatus": "VerificationRequired",
      });
      return; 
    }

    // 3. Analytics Processing
    double finalScore = calculateEngagementScore(currentStats);

    // 4. Boost Decision Execution
    await triggerSmartBoost(postId, finalScore);
  }
}