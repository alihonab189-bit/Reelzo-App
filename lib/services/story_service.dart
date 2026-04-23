import 'package:cloud_firestore/cloud_firestore.dart';

class StoryService {
static final _db = FirebaseFirestore.instance;

/// 📤 UPLOAD STORY
static Future<void> uploadStory({
required String userId,
required String image,
}) async {
await _db.collection("stories").add({
"userId": userId,
"image": image,
"viewers": [],
"time": FieldValue.serverTimestamp(),
});
}

/// 📖 GET STORIES (last 24h)
static Stream<QuerySnapshot> getStories() {
final now = DateTime.now().millisecondsSinceEpoch;
final last24h = now - (24 * 60 * 60 * 1000);

return _db
    .collection("stories")
    .where("time", isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(last24h))
    .snapshots();

}

/// 👁 ADD VIEW
static Future<void> addViewer(String storyId, String userId) async {
await _db.collection("stories").doc(storyId).update({
"viewers": FieldValue.arrayUnion([userId]),
});
}
}