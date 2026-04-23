import 'package:cloud_firestore/cloud_firestore.dart';

/// ==========================
/// GROUP MODEL
/// ==========================
class Group {
final String id;
final String name;
final String adminId;
final List<String> members;
final String? imageUrl;
final String description;
final bool isPrivate;

final DateTime createdAt;
final String lastMessage;
final DateTime lastMessageTime;

final Map<String, bool> typingStatus;

/// NEW 🔥
final Map<String, dynamic> memberRoles; // admin/mod/user
final Map<String, bool> onlineStatus; // user online/offline
final int totalMessages;
final int totalMembers;

Group({
required this.id,
required this.name,
required this.adminId,
required this.members,
this.imageUrl,
required this.description,
required this.isPrivate,
required this.createdAt,
required this.lastMessage,
required this.lastMessageTime,
required this.typingStatus,
required this.memberRoles,
required this.onlineStatus,
required this.totalMessages,
required this.totalMembers,
});

factory Group.fromMap(Map<String, dynamic> data, String id) {
return Group(
id: id,
name: data['name'] ?? 'Reelzo Group',
adminId: data['adminId'] ?? '',
members: List<String>.from(data['members'] ?? []),
imageUrl: data['imageUrl'],
description: data['description'] ?? '',
isPrivate: data['isPrivate'] ?? false,
createdAt: data['createdAt'] != null
? (data['createdAt'] as Timestamp).toDate()
: DateTime.now(),
lastMessage: data['lastMessage'] ?? '',
lastMessageTime: data['lastMessageTime'] != null
? (data['lastMessageTime'] as Timestamp).toDate()
: DateTime.now(),
typingStatus: Map<String, bool>.from(data['typingStatus'] ?? {}),
memberRoles: Map<String, dynamic>.from(data['memberRoles'] ?? {}),
onlineStatus: Map<String, bool>.from(data['onlineStatus'] ?? {}),
totalMessages: data['totalMessages'] ?? 0,
totalMembers: data['totalMembers'] ?? 0,
);
}

Map<String, dynamic> toMap() {
return {
'name': name,
'adminId': adminId,
'members': members,
'imageUrl': imageUrl,
'description': description,
'isPrivate': isPrivate,
'createdAt': createdAt,
'lastMessage': lastMessage,
'lastMessageTime': lastMessageTime,
'typingStatus': typingStatus,
'memberRoles': memberRoles,
'onlineStatus': onlineStatus,
'totalMessages': totalMessages,
'totalMembers': totalMembers,
};
}
}

/// ==========================
/// MESSAGE MODEL
/// ==========================
class Message {
final String id;
final String senderId;
final String senderName;

final String text;
final String? imageUrl;
final String? videoUrl;
final String? audioUrl;
final String? fileUrl;

final String type;
final DateTime time;

final List<String> seenBy;
final Map<String, String> reactions;

final bool isDeleted;
final bool isEdited;

final String? replyTo;

/// NEW 🔥
final String? thumbnail; // video preview
final double? fileSize; // KB/MB
final String? fileName;
final bool isForwarded;
final String? forwardedFrom;

Message({
required this.id,
required this.senderId,
required this.senderName,
required this.text,
this.imageUrl,
this.videoUrl,
this.audioUrl,
this.fileUrl,
required this.type,
required this.time,
required this.seenBy,
required this.reactions,
required this.isDeleted,
required this.isEdited,
this.replyTo,
this.thumbnail,
this.fileSize,
this.fileName,
this.isForwarded = false,
this.forwardedFrom,
});

factory Message.fromMap(Map<String, dynamic> data, String id) {
return Message(
id: id,
senderId: data['senderId'] ?? '',
senderName: data['senderName'] ?? 'User',
text: data['text'] ?? '',
imageUrl: data['imageUrl'],
videoUrl: data['videoUrl'],
audioUrl: data['audioUrl'],
fileUrl: data['fileUrl'],
type: data['type'] ?? 'text',
time: data['time'] != null
? (data['time'] as Timestamp).toDate()
: DateTime.now(),
seenBy: List<String>.from(data['seenBy'] ?? []),
reactions: Map<String, String>.from(data['reactions'] ?? {}),
isDeleted: data['isDeleted'] ?? false,
isEdited: data['isEdited'] ?? false,
replyTo: data['replyTo'],
thumbnail: data['thumbnail'],
fileSize: (data['fileSize'] as num?)?.toDouble(),
fileName: data['fileName'],
isForwarded: data['isForwarded'] ?? false,
forwardedFrom: data['forwardedFrom'],
);
}

Map<String, dynamic> toMap() {
return {
'senderId': senderId,
'senderName': senderName,
'text': text,
'imageUrl': imageUrl,
'videoUrl': videoUrl,
'audioUrl': audioUrl,
'fileUrl': fileUrl,
'type': type,
'time': time,
'seenBy': seenBy,
'reactions': reactions,
'isDeleted': isDeleted,
'isEdited': isEdited,
'replyTo': replyTo,
'thumbnail': thumbnail,
'fileSize': fileSize,
'fileName': fileName,
'isForwarded': isForwarded,
'forwardedFrom': forwardedFrom,
};
}
}