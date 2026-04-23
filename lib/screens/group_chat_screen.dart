import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';
import '../services/group_service.dart';

class GroupChatScreen extends StatefulWidget {
final String groupId;
final String userId;
final String userName;

const GroupChatScreen({
super.key,
required this.groupId,
required this.userId,
required this.userName,
});

@override
State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
final TextEditingController _controller = TextEditingController();
final ScrollController _scroll = ScrollController();

/// SEND MESSAGE
void send() async {
if (_controller.text.trim().isEmpty) return;

await GroupService.sendMessage(
  groupId: widget.groupId,
  senderId: widget.userId,
  senderName: widget.userName,
  text: _controller.text.trim(),
  type: "text",
);

GroupService.setTypingStatus(widget.groupId, widget.userId, false);

_controller.clear();

_scroll.animateTo(
  0,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOut,
);

HapticFeedback.mediumImpact();

}

/// FORMAT TIME
String formatTime(DateTime t) {
return "${t.hour}:${t.minute.toString().padLeft(2, '0')}";
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF0B141B),

  /// ================= APPBAR =================
  appBar: AppBar(
    backgroundColor: const Color(0xFF1B2D37),
    elevation: 3,
    title: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Text("Loading...");

        var data = snap.data!.data() as Map<String, dynamic>;
        Map typing = data["typingStatus"] ?? {};

        bool typingNow = typing.values.contains(true);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reelzo Group",
                style: TextStyle(fontSize: 16)),
            Text(
              typingNow ? "Typing..." : "Online",
              style: TextStyle(
                fontSize: 12,
                color: typingNow
                    ? Colors.greenAccent
                    : Colors.white54,
              ),
            )
          ],
        );
      },
    ),

    actions: [
      IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {}),
      IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {}),
    ],
  ),

  /// ================= BODY =================
  body: Column(
    children: [

      /// CHAT LIST
      Expanded(
        child: StreamBuilder<List<Message>>(
          stream: GroupService.getMessages(widget.groupId),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final msgs = snap.data!;

            return ListView.builder(
              controller: _scroll,
              reverse: true,
              itemCount: msgs.length,
              itemBuilder: (c, i) => messageBubble(msgs[i]),
            );
          },
        ),
      ),

      inputBar(),
    ],
  ),
);

}

/// ================= MESSAGE UI =================
Widget messageBubble(Message msg) {
bool isMe = msg.senderId == widget.userId;

return GestureDetector(
  onLongPress: () => messageOptions(msg),
  child: Align(
    alignment:
        isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin:
          const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF005C4B)
            : const Color(0xFF1F2C34),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (!isMe)
            Text(msg.senderName,
                style: const TextStyle(
                    color: Colors.orange, fontSize: 11)),

          /// TEXT
          if (!msg.isDeleted)
            Text(msg.text,
                style: const TextStyle(color: Colors.white)),

          if (msg.isDeleted)
            const Text("Message deleted",
                style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 5),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatTime(msg.time),
                  style: const TextStyle(
                      fontSize: 10, color: Colors.white54)),

              const SizedBox(width: 5),

              /// SEEN ✔✔
              if (isMe)
                Icon(
                  msg.seenBy.length > 1
                      ? Icons.done_all
                      : Icons.done,
                  size: 14,
                  color: msg.seenBy.length > 1
                      ? Colors.blue
                      : Colors.white54,
                ),
            ],
          )
        ],
      ),
    ),
  ),
);

}

/// ================= MESSAGE OPTIONS =================
void messageOptions(Message msg) {
showModalBottomSheet(
context: context,
builder: (_) => Column(
mainAxisSize: MainAxisSize.min,
children: [

      ListTile(
        leading: const Icon(Icons.favorite),
        title: const Text("React ❤️"),
        onTap: () {
          GroupService.addReaction(
            groupId: widget.groupId,
            messageId: msg.id,
            userId: widget.userId,
            emoji: "❤️",
          );
          Navigator.pop(context);
        },
      ),

      ListTile(
        leading: const Icon(Icons.edit),
        title: const Text("Edit"),
        onTap: () {
          GroupService.editMessage(
            groupId: widget.groupId,
            messageId: msg.id,
            newText: "Edited",
          );
          Navigator.pop(context);
        },
      ),

      ListTile(
        leading: const Icon(Icons.delete),
        title: const Text("Delete"),
        onTap: () {
          GroupService.deleteMessage(
            groupId: widget.groupId,
            messageId: msg.id,
          );
          Navigator.pop(context);
        },
      ),
    ],
  ),
);

}

/// ================= INPUT BAR =================
Widget inputBar() {
return Container(
padding: const EdgeInsets.all(8),
color: const Color(0xFF1F2C34),
child: Row(
children: [

      IconButton(
        icon: const Icon(Icons.emoji_emotions,
            color: Colors.white54),
        onPressed: () {},
      ),

      Expanded(
        child: TextField(
          controller: _controller,
          onChanged: (val) => GroupService.setTypingStatus(
              widget.groupId, widget.userId, val.isNotEmpty),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Message...",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),

      IconButton(
        icon:
            const Icon(Icons.attach_file, color: Colors.white54),
        onPressed: () {},
      ),

      IconButton(
        icon:
            const Icon(Icons.camera_alt, color: Colors.white54),
        onPressed: () {},
      ),

      GestureDetector(
        onTap: send,
        child: const CircleAvatar(
          backgroundColor: Color(0xFF00A884),
          child: Icon(Icons.send, color: Colors.white),
        ),
      ),
    ],
  ),
);

}
}