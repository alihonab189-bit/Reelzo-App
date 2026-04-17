import 'package:flutter/material.dart';
import '../services/call_service.dart';
import '../services/ai_chat_service.dart';
import '../services/ai_voice_service.dart';

class ReelzoAssistantScreen extends StatefulWidget { //
  const ReelzoAssistantScreen({super.key});

  @override
  State<ReelzoAssistantScreen> createState() => _ReelzoAssistantScreenState();
}

class _ReelzoAssistantScreenState extends State<ReelzoAssistantScreen> {
  String text = "Tap the mic to talk with Reelzo AI";

  Future<void> startCall() async {
    // User voice listen
    String userSpeech = await CallService.listen();
    if (userSpeech.isEmpty) return;

    setState(() {
      text = "You: $userSpeech";
    });

    // AI logic
    String reply = await AIChatService.sendMessage(
      userId: "user1",
      message: userSpeech,
    );

    setState(() {
      text = "AI: $reply";
    });

    // AI voice speak
    await AIVoiceService.speak(reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("AI Assistant"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.face, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: startCall,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.purple, blurRadius: 15, spreadRadius: 2)
                  ]
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Tap to Speak", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}