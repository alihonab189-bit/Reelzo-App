import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';

class GroupService {
static final FirebaseFirestore _db = FirebaseFirestore.instance;

/// ==========================
/// CREATE GROUP (ADVANCED)
/// ==========================
static Future<String> createGroup({
required String name,
required String adminId,
required List<String> members,
String? imageUrl,
}) async {
final doc = _db.collection("groups").doc();

Group group = Group(
  id: doc.id,
  name: name,
  adminId: adminId,
  members: members,
  imageUrl: imageUrl,
  description: "Welcome to $name",
  isPrivate: false,
  createdAt: DateTime.now(),
  lastMessage: "Group Created",
  lastMessageTime: DateTime.now(),
  typingStatus: {},
  memberRoles: {adminId: "admin"},
  onlineStatus: {},
  totalMessages: 0,
  totalMembers: members.length,
);

await doc.set(group.toMap());
return doc.id;

}

/// ==========================
/// SEND MESSAGE (PRO LEVEL)
/// ==========================
static Future<void> sendMessage({
required String groupId,
required String senderId,
required String senderName,
String text = "",
String? mediaUrl,
required String type,
String? replyTo,
String? fileName,
double? fileSize,
}) async {
final groupRef = _db.collection("groups").doc(groupId);
final msgRef = groupRef.collection("messages").doc();

final message = Message(
  id: msgRef.id,
  senderId: senderId,
  senderName: senderName,
  text: text,
  imageUrl: type == "image" ? mediaUrl : null,
  videoUrl: type == "video" ? mediaUrl : null,
  audioUrl: type == "audio" ? mediaUrl : null,
  fileUrl: type == "file" ? mediaUrl : null,
  type: type,
  time: DateTime.now(),
  seenBy: [senderId],
  reactions: {},
  isDeleted: false,
  isEdited: false,
  replyTo: replyTo,
  fileName: fileName,
  fileSize: fileSize,
);

WriteBatch batch = _db.batch();

batch.set(msgRef, message.toMap());

batch.update(groupRef, {
  "lastMessage": type == "text" ? text : "📎 Media",
  "lastMessageTime": FieldValue.serverTimestamp(),
  "totalMessages": FieldValue.increment(1),
});

await batch.commit();

}

/// ==========================
/// SEEN ✔✔ UPDATE
/// ==========================
static Future<void> markAsSeen({
required String groupId,
required String messageId,
required String userId,
}) async {
await _db
.collection("groups")
.doc(groupId)
.collection("messages")
.doc(messageId)
.update({
"seenBy": FieldValue.arrayUnion([userId]),
});
}

/// ==========================
/// REACTION ❤️🔥👍
/// ==========================
static Future<void> addReaction({
required String groupId,
required String messageId,
required String userId,
required String emoji,
}) async {
await _db
.collection("groups")
.doc(groupId)
.collection("messages")
.doc(messageId)
.update({
"reactions.$userId": emoji,
});
}

/// ==========================
/// DELETE MESSAGE
/// ==========================
static Future<void> deleteMessage({
required String groupId,
required String messageId,
}) async {
await _db
.collection("groups")
.doc(groupId)
.collection("messages")
.doc(messageId)
.update({
"isDeleted": true,
"text": "Message deleted",
});
}

/// ==========================
/// EDIT MESSAGE
/// ==========================
static Future<void> editMessage({
required String groupId,
required String messageId,
required String newText,
}) async {
await _db
.collection("groups")
.doc(groupId)
.collection("messages")
.doc(messageId)
.update({
"text": newText,
"isEdited": true,
});
}

/// ==========================
/// TYPING INDICATOR
/// ==========================
static Future<void> setTypingStatus(
String groupId, String userId, bool isTyping) async {
await _db.collection("groups").doc(groupId).update({
"typingStatus.$userId": isTyping,
});
}

/// ==========================
/// ONLINE STATUS
/// ==========================
static Future<void> setOnlineStatus(
String groupId, String userId, bool online) async {
await _db.collection("groups").doc(groupId).update({
"onlineStatus.$userId": online,
});
}

/// ==========================
/// GET MESSAGES (OPTIMIZED)
/// ==========================
static Stream<List<Message>> getMessages(String groupId) {
return _db
.collection("groups")
.doc(groupId)
.collection("messages")
.orderBy("time", descending: true)
.limit(50)
.snapshots()
.map((snap) =>
snap.docs.map((d) => Message.fromMap(d.data(), d.id)).toList());
}

/// ==========================
/// PAGINATION (LOAD MORE)
/// ==========================
static Future<List<Message>> loadMoreMessages(
String groupId, DocumentSnapshot lastDoc) async {
final snap = await _db
.collection("groups")
.doc(groupId)
.collection("messages")
.orderBy("time", descending: true)
.startAfterDocument(lastDoc)
.limit(50)
.get();

return snap.docs.map((d) => Message.fromMap(d.data(), d.id)).toList();

}
}