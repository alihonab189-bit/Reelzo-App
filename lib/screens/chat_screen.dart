import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/chat_service.dart';
import '../services/online_service.dart';
import '../services/ai_chat_service.dart'; 
import 'ai_assistant_screen.dart';
import 'group_chat_screen.dart'; 

class ChatScreen extends StatefulWidget {
  final String myId;
  final String otherId;
  final String? otherName;

  const ChatScreen({super.key, required this.myId, required this.otherId, this.otherName});

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

  /// Handle message sending logic for both User and AI
  Future<void> handleSendMessage() async {
    final String msg = controller.text.trim();
    if (msg.isEmpty) return;

    controller.clear();
    ChatService.setTyping(widget.myId, false);

    // 1. Dispatch User Message
    await ChatService.sendMessage(
      from: widget.myId,
      to: widget.otherId,
      text: msg,
    );

    // 2. Process AI Automated Reply
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

      /// 🔝 APPBAR: Status Indicator & Action Shortcuts
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: StreamBuilder(
          stream: OnlineService.getStatus(widget.otherId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text(widget.otherName ?? "User", style: const TextStyle(fontSize: 16));

            var data = snapshot.data!.data() as Map?;
            bool online = data?["online"] ?? false;
            bool typing = data?["typing"] ?? false;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherName ?? "User", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (typing)
                  const Text("Typing...", style: TextStyle(fontSize: 12, color: Colors.greenAccent))
                else
                  Text(online ? "Online" : "Offline", style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            );
          },
        ),
        actions: [
          /// Call/AI Assistant Trigger
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            tooltip: "Call Assistant",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReelzoAssistantScreen()),
              );
            },
          ),
          
          /// Group Chat Quick Access (Instagram Style)
          IconButton(
            icon: const Icon(Icons.group_add_rounded, color: Colors.blueAccent),
            tooltip: "Global Group",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupChatScreen(
                    groupId: "global_reelzo_room", 
                    userId: widget.myId,
                    userName: "User", 
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          /// 💬 Chat History Display
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

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

                    // Update Read Receipts
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
                            Text(data["text"] ?? "", style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 4),
                            if (me)
                              Text(
                                data["seen"] == true ? "Read" : "Sent",
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

          /// ✍ Message Composer
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