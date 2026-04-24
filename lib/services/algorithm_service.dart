/// ===============================
/// FILE: lib/services/algorithm_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class AlgorithmService {

static final _db = FirebaseFirestore.instance;

/// 🧠 GET SMART REELS
static Stream<QuerySnapshot> getReels() {
  final String uid = AuthService.currentUser!.uid;//

return _db
    .collection("reels")
    .orderBy("createdAt", descending: true)
    .snapshots();

}

/// ❤️ LIKE TRACK
static Future<void> likeReel(String reelId) async {
String uid = AuthService.currentUser!.uid;

await _db.collection("likes").add({
  "userId": uid,
  "reelId": reelId,
  "time": FieldValue.serverTimestamp(),
});

}

/// ⏱ WATCH TIME TRACK
static Future<void> watchReel(String reelId, int seconds) async {
String uid = AuthService.currentUser!.uid;

await _db.collection("watch").add({
  "userId": uid,
  "reelId": reelId,
  "seconds": seconds,
  "time": FieldValue.serverTimestamp(),
});

}

/// 🔥 TRENDING BOOST
static Future<void> boostReel(String reelId) async {
await _db.collection("reels").doc(reelId).update({
"boost": FieldValue.increment(1),
});
}
}