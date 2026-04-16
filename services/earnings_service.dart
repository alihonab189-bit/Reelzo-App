/// ===============================
/// FILE: lib/services/earnings_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class EarningsService {

static final _db = FirebaseFirestore.instance;

static Stream<double> getTotalEarnings() {
return _db.collection("payments").snapshots().map((snapshot) {
double total = 0;
for (var doc in snapshot.docs) {
total += (doc["amount"] ?? 0);
}
return total;
});
}
}