import 'ai_moderation_service.dart';
import 'ban_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addComment(String userId, String text) async {
  // 1. Check if the text is bad using AI
  bool bad = await AIModerationService.isBad(text);

  if (bad) {
    // 2. If bad, add a strike and stop
    await BanService.addStrike(userId);
    return;
  }

  // 3. If good, save the comment to Firestore
  await FirebaseFirestore.instance.collection("comments").add({
    "userId": userId,
    "text": text,
    "timestamp": FieldValue.serverTimestamp(),
  });
} 