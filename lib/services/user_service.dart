/// ===============================
/// FILE: lib/services/user_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

static final _db = FirebaseFirestore.instance;

/// Create user
static Future<void> createUser(String uid) async {
await _db.collection("users").doc(uid).set({
"online": true,
"followers": 0,
"createdAt": FieldValue.serverTimestamp(),
});
}

/// Online status
static Future<void> setOnline(bool status) async {
String uid = "user_1"; // 🔥 replace with auth uid later
await _db.collection("users").doc(uid).update({
"online": status,
});
}

/// Get online status
static Stream<bool> getOnline(String uid) {
return _db.collection("users").doc(uid).snapshots().map((doc) {
return doc.data()?["online"] ?? false;
});
}

/// Block user
static Future<void> blockUser(String targetId) async {
await _db.collection("blocks").add({
"blockedUser": targetId,
});
}

/// Unblock user
static Future<void> unblockUser(String targetId) async {
var snapshot = await _db
.collection("blocks")
.where("blockedUser", isEqualTo: targetId)
.get();

for (var doc in snapshot.docs) {
  await doc.reference.delete();
}

}

/// Check blocked
static Stream<bool> isBlocked(String targetId) {
return _db
.collection("blocks")
.where("blockedUser", isEqualTo: targetId)
.snapshots()
.map((snap) => snap.docs.isNotEmpty);
}
}