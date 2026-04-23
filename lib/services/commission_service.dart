/// ===============================
/// FILE: lib/services/commission_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class CommissionService {

static final _db = FirebaseFirestore.instance;

static Future<void> applyCommission(double amount) async {

double commission = amount * 0.01;

await _db.collection("earnings").add({
  "type": "commission",
  "amount": commission,
  "time": FieldValue.serverTimestamp(),
});

}
}