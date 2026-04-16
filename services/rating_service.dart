/// ===============================
/// FILE: lib/services/rating_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class RatingService {
static final _db = FirebaseFirestore.instance;

static Future<void> rateApp(double rating) async {
await _db.collection("ratings").add({
"rating": rating,
"time": FieldValue.serverTimestamp(),
});
}
}