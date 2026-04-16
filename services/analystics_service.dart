/// ===============================
/// FILE: lib/services/analytics_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  static final _db = FirebaseFirestore.instance;

  /// 📊 TRACK ANALYTICS EVENT
  static Future<void> trackEvent(String event) async {
    await _db.collection("analytics").add({
      "event": event,
      "time": FieldValue.serverTimestamp(),
    });
  }

  /// 💰 ADD EARNING TO USER WALLET
  static Future<void> addEarning(String userId, int views) async {
    // 1. Calculate earning (₹ 0.01 per view)
    double earning = views * 0.01;

    // 2. Save/Update to user's wallet in Firestore
    await _db.collection("wallets").doc(userId).set({
      "userId": userId,
      "totalEarning": FieldValue.increment(earning),
      "lastUpdated": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other data
  }

  /// 📈 GET ANALYTICS DATA
  static Stream<QuerySnapshot> getAnalytics() {
    return _db.collection("analytics")
        .orderBy("time", descending: true)
        .snapshots();
  }
}