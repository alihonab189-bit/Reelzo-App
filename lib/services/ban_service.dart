import 'package:cloud_firestore/cloud_firestore.dart';

class BanService {

static final _db = FirebaseFirestore.instance;

/// ⚠️ ADD STRIKE
static Future<void> addStrike(String userId) async {
var ref = _db.collection("users").doc(userId);

await _db.runTransaction((t) async {
  var snap = await t.get(ref);

  int strike = snap["strike"] ?? 0;
  strike++;

  if (strike >= 3) {
    t.update(ref, {
      "strike": strike,
      "banned": true,
    });
  } else {
    t.update(ref, {
      "strike": strike,
    });
  }
});

}

/// 🚫 CHECK BAN
static Future<bool> isBanned(String userId) async {
var snap = await _db.collection("users").doc(userId).get();
return snap["banned"] ?? false;
}
}