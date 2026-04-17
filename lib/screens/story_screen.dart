import 'package:flutter/material.dart';
import '../services/story_service.dart';
// 1. Importing the Custom Delete Button Widget
import '../widgets/delete_button.dart';

class StoryScreen extends StatelessWidget {
  final String storyId;
  final String image;

  const StoryScreen({super.key, required this.storyId, required this.image});

  @override
  Widget build(BuildContext context) {
    /// 👁 ADD VIEW
    StoryService.addViewer(storyId, "user1");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🖼 STORY IMAGE
          Center(
            child: Image.network(image, fit: BoxFit.cover),
          ),

          /// 🔝 CLOSE BUTTON
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// 🗑 DELETE BUTTON (Added at Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: DeleteButton(
              collection: "stories", // Targeted collection
              docId: storyId,        // Passing the Story ID
            ),
          ),

          /// 💬 REPLY BOX
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Reply...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onSubmitted: (text) {
                // 👉 logic to send to chat
              },
            ),
          ),
        ],
      ),
    );
  }
}