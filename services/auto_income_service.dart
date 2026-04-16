/// ===============================
/// FILE: lib/services/auto_income_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class AutoIncomeService {

static final _db = FirebaseFirestore.instance;

/// 💰 TRACK EARNING
static Future<void> addIncome({
required String type,
required double amount,
}) async {

await _db.collection("earnings").add({
  "type": type,
  "amount": amount,
  "time": FieldValue.serverTimestamp(),
});

}

/// 📊 TOTAL EARNING
static Stream<double> total() {
return _db.collection("earnings").snapshots().map((snap) {
double total = 0;
for (var doc in snap.docs) {
total += (doc["amount"] ?? 0);
}
return total;
});
}
}