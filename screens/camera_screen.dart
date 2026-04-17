import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// 1. Importing the Creator Dashboard
import 'creator_dashboard.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  String mode = "Reel"; // Reel, Post, Story, News, Product

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.high);
      await controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// 📸 CAPTURE LOGIC
  Future<void> capture() async {
    if (controller == null || !controller!.value.isInitialized) return;

    final file = await controller!.takePicture();

    /// 🚫 AI BLOCK FOR NEWS & PRODUCT
    if (mode == "News" || mode == "Product") {
      if (mounted) Navigator.pop(context);
      return;
    }

    /// 👉 GO TO UPLOAD
    if (mounted) {
      Navigator.pop(context, {
        "file": file.path,
        "mode": mode,
      });
    }
  }

  void changeMode(String newMode) {
    setState(() {
      mode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        // 2. Swipe logic to navigate to Creator Dashboard
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreatorDashboard(),
              ),
            );
          }
        },
        child: Stack(
          children: [
            /// 📷 CAMERA PREVIEW
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: CameraPreview(controller!),
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

            /// 🔻 MODE SELECTOR
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    modeButton("Reel"),
                    modeButton("Post"),
                    modeButton("Story"),
                    modeButton("News"),
                    modeButton("Product"),
                  ],
                ),
              ),
            ),

            /// 🔴 CAPTURE BUTTON
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: capture,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 MODE BUTTON WIDGET
  Widget modeButton(String text) {
    bool active = mode == text;
    return GestureDetector(
      onTap: () => changeMode(text),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.purpleAccent : Colors.white70,
            fontSize: active ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}