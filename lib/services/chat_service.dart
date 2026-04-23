import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final _db = FirebaseFirestore.instance;

  /// 💬 SEND MESSAGE (With Seen & Typing status)
  static Future<void> sendMessage({
    required String from,
    required String to,
    required String text,
  }) async {
    try {
      await _db.collection("chats").add({
        "from": from,
        "to": to,
        "text": text,
        "seen": false,
        "time": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  /// 📩 GET MESSAGES (Real-time Stream with 100 limit)
  static Stream<QuerySnapshot> getMessages() {
    return _db
        .collection("chats")
        .orderBy("time", descending: false)
        .limit(100) // 
        .snapshots();
  }

  /// 👁 MARK AS SEEN
  static Future<void> markSeen(String docId) async {
    try {
      await _db.collection("chats").doc(docId).update({"seen": true});
    } catch (e) {
      print("Error marking seen: $e");
    }
  }

  /// ✍️ TYPING STATUS (Update in User Collection)
  static Future<void> setTyping(String userId, bool typing) async {
    try {
      await _db.collection("users").doc(userId).set({
        "typing": typing,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error setting typing status: $e");
    }
  }
}