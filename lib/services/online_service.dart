import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineService {
  static final _db = FirebaseFirestore.instance;

  /// Update user status to Online
  static Future<void> setOnline(String userId) async {
    try {
      await _db.collection("users").doc(userId).set({
        "online": true,
        "lastSeen": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error setting online: $e");
    }
  }

  /// Update user status to Offline
  static Future<void> setOffline(String userId) async {
    try {
      await _db.collection("users").doc(userId).set({
        "online": false,
        "lastSeen": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error setting offline: $e");
    }
  }

  /// Get real-time status of a user
  static Stream<DocumentSnapshot> getStatus(String userId) {
    return _db.collection("users").doc(userId).snapshots();
  }
}