import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
static final _db = FirebaseFirestore.instance;

/// 🆕 Create wallet
static Future<void> createWallet(String userId) async {
await _db.collection("wallets").doc(userId).set({
"balance": 0.0,
});
}

/// 💰 Add money
static Future<void> addMoney(String userId, double amount) async {
var ref = _db.collection("wallets").doc(userId);

await _db.runTransaction((t) async {
  var snap = await t.get(ref);
  double current = snap["balance"] ?? 0;
  t.update(ref, {"balance": current + amount});
});

}

/// 💸 Send money
static Future<void> sendMoney({
required String from,
required String to,
required double amount,
}) async {

var fromRef = _db.collection("wallets").doc(from);
var toRef = _db.collection("wallets").doc(to);

await _db.runTransaction((t) async {
  var fromSnap = await t.get(fromRef);
  var toSnap = await t.get(toRef);

  double fromBalance = fromSnap["balance"] ?? 0;
  double toBalance = toSnap["balance"] ?? 0;

  if (fromBalance >= amount) {
    t.update(fromRef, {"balance": fromBalance - amount});
    t.update(toRef, {"balance": toBalance + amount});
  }
});

}

/// 📊 Get balance
static Stream<DocumentSnapshot> getBalance(String userId) {
return _db.collection("wallets").doc(userId).snapshots();
}
}