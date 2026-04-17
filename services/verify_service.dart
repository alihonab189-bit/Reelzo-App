/// ===============================
/// FILE: lib/services/verify_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyService {
static final _db = FirebaseFirestore.instance;

static Future<void> requestVerification(String userId) async {
await _db.collection("verifications").add({
"userId": userId,
"status": "pending",
"time": FieldValue.serverTimestamp(),
});
}

static Future<void> approve(String docId) async {
await _db.collection("verifications").doc(docId).update({
"status": "approved",
});
}
}