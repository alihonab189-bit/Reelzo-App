import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/chat_service.dart';
import '../services/online_service.dart';
import '../services/ai_chat_service.dart'; 
import 'ai_assistant_screen.dart';

class ChatScreen extends StatefulWidget {
  final String myId;
  final String otherId;

  const ChatScreen({super.key, required this.myId, required this.otherId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    OnlineService.setOnline(widget.myId);
  }

  @override
  void dispose() {
    OnlineService.setOffline(widget.myId);
    controller.dispose();
    super.dispose();
  }

  Future<void> handleSendMessage() async {
    final String msg = controller.text.trim();
    if (msg.isEmpty) return;

    controller.clear();
    ChatService.setTyping(widget.myId, false);

    // 1. Send User Message
    await ChatService.sendMessage(
      from: widget.myId,
      to: widget.otherId,
      text: msg,
    );

    // 2. Trigger AI reply if receiver is AI
    if (widget.otherId == "ai_user") {
      String reply = await AIChatService.sendMessage(
        userId: widget.myId,
        message: msg,
      );

      await ChatService.sendMessage(
        from: widget.otherId,
        to: widget.myId,
        text: reply,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔝 APPBAR: Shows Online/Offline and Typing Status
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: StreamBuilder(
          stream: OnlineService.getStatus(widget.otherId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("User");

            var data = snapshot.data!.data() as Map?;
            bool online = data?["online"] ?? false;
            bool typing = data?["typing"] ?? false;

            if (typing) {
              return const Text(
                "Typing... ✍️",
                style: TextStyle(fontSize: 14, color: Colors.greenAccent),
              );
            }
            return Text(
              online ? "Online 🟢" : "Offline 🔴",
              style: const TextStyle(fontSize: 16),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReelzoAssistantScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          /// 💬 MESSAGES LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                // Filter messages only between me and other user
                final filteredDocs = docs.where((d) {
                  return (d["from"] == widget.myId && d["to"] == widget.otherId) ||
                         (d["from"] == widget.otherId && d["to"] == widget.myId);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, i) {
                    final d = filteredDocs[i];
                    final data = d.data() as Map<String, dynamic>;
                    bool me = data["from"] == widget.myId;

                    /// 👁 MARK AS SEEN
                    if (!me && data["to"] == widget.myId && data["seen"] == false) {
                      ChatService.markSeen(d.id);
                    }

                    return Align(
                      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: me ? Colors.purple : Colors.grey[800],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: Radius.circular(me ? 15 : 0),
                            bottomRight: Radius.circular(me ? 0 : 15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["text"] ?? "",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            if (me)
                              Text(
                                data["seen"] == true ? "✓✓" : "✓",
                                style: const TextStyle(color: Colors.white54, fontSize: 10),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// ✍ INPUT FIELD
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onChanged: (val) {
                      ChatService.setTyping(widget.myId, val.isNotEmpty);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: handleSendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}