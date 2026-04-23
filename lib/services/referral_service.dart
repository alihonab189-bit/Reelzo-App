/// ===============================
/// FILE: lib/services/referral_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralService {

static final _db = FirebaseFirestore.instance;

static Future<void> refer(String userId) async {
await _db.collection("referrals").add({
"userId": userId,
"reward": 5, // ₹5 bonus
"time": FieldValue.serverTimestamp(),
});
}
}