/// ===============================
/// FILE: lib/services/sponsored_reel_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoredReelService {

static final _db = FirebaseFirestore.instance;

static Future<void> createAd(String videoUrl) async {
await _db.collection("ads").add({
"video": videoUrl,
"type": "sponsored",
"time": FieldValue.serverTimestamp(),
});
}
}