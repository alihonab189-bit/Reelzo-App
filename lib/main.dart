import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Mandatory for Multi-platform support
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/upload_service.dart'; 
import 'services/voice_ai_service.dart'; 

// --- Reelzo Brand Identity: Professional Gradient ---
const LinearGradient reelzoGradient = LinearGradient(
  colors: [Color(0xFFFF2E63), Color(0xFF7F00FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

void main() async {
  // Ensure framework is properly initialized before background services
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with Platform-Specific Configurations (Android, iOS, Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Global exception tracking to prevent silent crashes
  FlutterError.onError = (details) {
    debugPrint("Reelzo Production Error: ${details.exception}");
  };

  // Automated background synchronization for authenticated users
  if (AuthService.currentUser != null) {
    UploadService.autoUpload(AuthService.currentUser!.uid);
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reelzo',
      debugShowCheckedModeBanner: false,
      // High-performance Dark UI Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF2E63),
          secondary: Color(0xFF7F00FF),
          surface: Color(0xFF121212),
        ),
      ),
      home: const GlobalAIWrapper(),
    );
  }
}

class GlobalAIWrapper extends StatefulWidget {
  const GlobalAIWrapper({super.key});

  @override
  State<GlobalAIWrapper> createState() => _GlobalAIWrapperState();
}

class _GlobalAIWrapperState extends State<GlobalAIWrapper> {
  // Initial screen coordinate for the Floating AI Widget
  Offset position = const Offset(20, 200); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Auth State Controller
          AuthService.currentUser == null ? const LoginScreen() : const HomeScreen(),

          // Draggable UI Layer for Global AI Assistant
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              feedback: _buildMiniAIButton(opacity: 0.6),
              childWhenDragging: const SizedBox.shrink(),
              onDragEnd: (details) {
                setState(() {
                  // Update position after drag gesture completion
                  position = details.offset;
                });
              },
              child: _buildMiniAIButton(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the interactive AI Floating Action Button
  Widget _buildMiniAIButton({double opacity = 1.0}) {
    return Material(
      elevation: 12,
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          onTap: () {
            VoiceAIService.speak("Hi Hoonab, I am Reelzo AI. How can I assist you today?");
          },
          child: Container(
            width: 48, // Optimized touch target size
            height: 48,
            decoration: const BoxDecoration(
              gradient: reelzoGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 2)
              ],
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }
}