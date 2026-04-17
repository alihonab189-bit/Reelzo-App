/// ===============================
/// FILE: lib/services/reward_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class RewardService {

static final _db = FirebaseFirestore.instance;

static Future<void> dailyReward(String userId) async {

await _db.collection("rewards").add({
  "userId": userId,
  "amount": 2,
  "time": FieldValue.serverTimestamp(),
});

}
}