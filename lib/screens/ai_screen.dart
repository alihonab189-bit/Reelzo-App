import 'package:flutter/material.dart';
import '../services/real_ai_service.dart';

class AiScreen extends StatefulWidget {
const AiScreen({super.key});

@override
State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
final TextEditingController controller = TextEditingController();

List<Map<String, String>> chat = [];
bool loading = false;

Future<void> sendMessage() async {
String text = controller.text.trim();
if (text.isEmpty) return;

setState(() {
  chat.add({"role": "user", "text": text});
  loading = true;
});

controller.clear();

try {
  String reply = await RealAIService.chat(text);

  setState(() {
    chat.add({"role": "ai", "text": reply});
  });
} catch (e) {
  setState(() {
    chat.add({"role": "ai", "text": "AI Error ❌"});
  });
}

setState(() {
  loading = false;
});

}

Widget messageBubble(String text, bool isUser) {
return Align(
alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
child: Container(
margin: const EdgeInsets.all(8),
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: isUser ? Colors.deepPurple : Colors.grey[800],
borderRadius: BorderRadius.circular(15),
),
child: Text(
text,
style: const TextStyle(color: Colors.white),
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,

  appBar: AppBar(
    backgroundColor: Colors.black,
    title: const Text("🤖 AI Assistant"),
  ),

  body: Column(
    children: [

      /// CHAT
      Expanded(
        child: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (context, index) {
            final msg = chat[index];
            return messageBubble(
              msg["text"] ?? "",
              msg["role"] == "user",
            );
          },
        ),
      ),

      if (loading)
        const Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(),
        ),

      /// INPUT
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.black,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ask anything...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: sendMessage,
            )
          ],
        ),
      )

    ],
  ),
);

}
}