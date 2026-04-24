import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/upload_service.dart';
import '../services/unified_ai_engine.dart';
import '../services/trust_engine.dart';

class UploadReelScreen extends StatefulWidget {
  const UploadReelScreen({super.key});

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {
  File? videoFile;
  final TextEditingController captionController = TextEditingController();
  bool loading = false;

  /// Select video from gallery
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        videoFile = File(picked.path);
      });
    }
  }

  /// Execute upload process with AI and Trust checks
  Future<void> upload() async {
    String userId = "user1"; // Replace with actual Firebase UID
    String caption = captionController.text;
    String reelId = DateTime.now().millisecondsSinceEpoch.toString();

    if (videoFile == null) {
      _showSnackBar("Please select a video first!");
      return;
    }

    setState(() => loading = true);

    try {
      // 1. Unified AI Engine Scan for Moderation
      await UnifiedAIEngine.run(
        userId: userId,
        postId: reelId,
        text: caption,
        data: {
          "likes": 0,
          "comments": 0,
          "shares": 0,
          "views": 0,
        },
      );

      // 2. Video File Upload
      await UploadService.uploadReel(
        video: videoFile!.path,
        caption: caption,
        userId: userId,
      );

      // 3. Update User Trust Score
      await TrustEngine.run(
        userId: userId,
        contentData: {
          "views": 0, 
          "likes": 0,
        },
        likes: 0,
        reports: 0,
      );

      if (mounted) {
        _showSnackBar("Reel Published & AI Verified! 🚀✅");
        setState(() {
          videoFile = null;
          captionController.clear();
        });
      }
    } catch (e) {
      if (mounted) _showSnackBar("Upload Failed! ❌ Please try again.");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Upload Reel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          /// Preview Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Center(
                child: videoFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_creation_outlined, color: Colors.white24, size: 80),
                          SizedBox(height: 10),
                          Text("Select a video to start", style: TextStyle(color: Colors.white24)),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 100),
                          const SizedBox(height: 10),
                          const Text("Ready to Go!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(videoFile!.path.split('/').last, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                        ],
                      ),
              ),
            ),
          ),

          /// Caption Input Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: captionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Add a caption... #viral #reelzo",
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.pinkAccent, width: 1),
                ),
              ),
            ),
          ),

          /// Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: loading ? null : pickVideo,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : upload,
                    icon: loading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.rocket_launch),
                    label: Text(loading ? "Processing..." : "Share Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}