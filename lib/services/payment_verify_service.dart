/// ===============================
/// FILE: lib/services/payment_verify_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentVerifyService {

static final _db = FirebaseFirestore.instance;

/// 🔍 Auto verify (manual logic upgrade ready)
static Future<void> verifyPayment(String paymentId) async {
await _db.collection("payments").doc(paymentId).update({
"status": "verified",
});
}
}