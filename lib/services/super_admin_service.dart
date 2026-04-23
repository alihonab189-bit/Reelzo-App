import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminService {
static final _db = FirebaseFirestore.instance;

/// 🚫 AUTO BAN SYSTEM
static Future<void> checkAndBan(String userId, String text) async {
List<String> badWords = ["sex", "spam", "hack", "fraud"];

for (var word in badWords) {
  if (text.toLowerCase().contains(word)) {
    await _db.collection("users").doc(userId).set({
      "banned": true,
    }, SetOptions(merge: true));
  }
}

}

/// 🤖 CONTENT MODERATION
static Future<bool> isSafe(String text) async {
List<String> badWords = ["sex", "hack", "fraud"];
for (var word in badWords) {
if (text.toLowerCase().contains(word)) {
return false;
}
}
return true;
}

/// 💰 PAYMENT VERIFY (BASIC)
static Future<bool> verifyPayment(double amount) async {
if (amount > 0) {
return true;
}
return false;
}

/// 📊 USER TRACKING
static Future<void> trackUser(String userId, String action) async {
await _db.collection("analytics").add({
"userId": userId,
"action": action,
"time": FieldValue.serverTimestamp(),
});
}
}