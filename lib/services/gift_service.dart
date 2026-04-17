import 'package:cloud_firestore/cloud_firestore.dart';

class GiftService {
static final _db = FirebaseFirestore.instance;

/// 🎁 SEND GIFT
static Future<void> sendGift({
required String from,
required String to,
required int coins,
}) async {

await _db.collection("gifts").add({
  "from": from,
  "to": to,
  "coins": coins,
  "time": FieldValue.serverTimestamp(),
});

/// 💰 Add earning to creator
await _db.collection("wallets").doc(to).update({
  "balance": FieldValue.increment(coins * 0.5),
});

}
}