import 'package:cloud_firestore/cloud_firestore.dart';

class RelationshipService {
  static final _db = FirebaseFirestore.instance;

  /// 💾 SAVE MEMORY: Stores special relationship moments in Firestore
  static Future<void> saveMemory(String userId, String text) async {
    try {
      await _db.collection("relationships").doc(userId).set({
        "memory": FieldValue.arrayUnion([text]),
        "last_updated": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving memory: $e");
    }
  }

  /// 📖 GET MEMORY: Retrieves all stored memories for a specific user
  static Future<List<dynamic>> getMemory(String userId) async {
    try {
      var snap = await _db.collection("relationships").doc(userId).get();
      return snap.data()?["memory"] ?? [];
    } catch (e) {
      print("Error fetching memory: $e");
      return [];
    }
  }

  /// 💘 SEND REQUEST: Sends a relationship request to another user
  static Future<void> sendRequest(String myId, String partnerId) async {
    try {
      await _db.collection("relationship_requests").add({
        "senderId": myId,
        "receiverId": partnerId,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  /// 💔 BREAK UP: Removes the relationship record from the database
  static Future<void> breakUp(String docId) async {
    try {
      await _db.collection("relationships").doc(docId).delete();
      print("Relationship record deleted successfully");
    } catch (e) {
      print("Error during breakUp: $e");
    }
  }
}