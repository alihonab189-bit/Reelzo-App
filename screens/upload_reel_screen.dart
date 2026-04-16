import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/upload_service.dart';
// 🔥 Importing SuperAdminService for safety and tracking
import '../services/super_admin_service.dart';

class UploadReelScreen extends StatefulWidget {
  const UploadReelScreen({super.key});

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {
  File? videoFile;
  final TextEditingController captionController = TextEditingController();
  bool loading = false;

  /// PICK VIDEO
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        videoFile = File(picked.path);
      });
    }
  }

  /// UPLOAD REEL WITH SAFETY CHECKS
  Future<void> upload() async {
    String userId = "user1"; // Currently hardcoded as per your request
    String caption = captionController.text;

    if (videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video first!")),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // 1. 👉 Safety check before pressing upload
      bool safe = await SuperAdminService.isSafe(caption);
      if (!safe) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Inappropriate content detected! ❌")),
          );
        }
        setState(() => loading = false);
        return;
      }

      // 2. 👉 Check and Ban logic during upload process
      await SuperAdminService.checkAndBan(userId, caption);

      // Main Uploading Logic
      await UploadService.uploadReel(
        video: videoFile!.path,
        caption: caption,
        userId: userId,
      );

      // 3. 👉 Track user on successful upload
      await SuperAdminService.trackUser(userId, "reel_upload");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload Success ✅")),
        );
      }

      setState(() {
        videoFile = null;
        captionController.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload Failed ❌")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Upload Reel",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          /// PREVIEW SECTION
          Expanded(
            child: Center(
              child: videoFile == null
                  ? const Text(
                      "No Video Selected",
                      style: TextStyle(color: Colors.white70),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 100),
                        SizedBox(height: 10),
                        Text("Video Ready", style: TextStyle(color: Colors.white)),
                      ],
                    ),
            ),
          ),

          /// CAPTION SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
              controller: captionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write caption...",
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
          ),

          /// ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: loading ? null : pickVideo,
                  icon: const Icon(Icons.video_library),
                  label: const Text("Select Video"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: loading ? null : upload,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            ),
        ],
      ),
    );
  }
}