import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; 
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/upload_service.dart'; 
import 'services/voice_ai_service.dart'; 
import 'services/payment_alert_service.dart'; // 🔥 High-Performance Payment Alert Service

// --- Reelzo Brand Identity: Professional Gradient ---
const LinearGradient reelzoGradient = LinearGradient(
  colors: [Color(0xFFFF2E63), Color(0xFF7F00FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

void main() async {
  // 1. Ensure framework is properly initialized before background services
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase with Multi-Platform Configurations
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🛠️ 3. Initialize the Payment Voice Alert Service (Crucial for Real-time Response)
  // This pre-loads the Text-to-Speech engine so that payments are announced instantly.
  await PaymentAlertService().init(); 

  // Global exception tracking to prevent silent crashes in production
  FlutterError.onError = (details) {
    debugPrint("Reelzo Production Error: ${details.exception}");
  };

  // Automated background synchronization for authenticated users
  if (FirebaseAuth.instance.currentUser != null) {
    UploadService.autoUpload(FirebaseAuth.instance.currentUser!.uid);
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
      // High-performance Dark UI Theme optimized for 2026 standards
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
          // Dynamic Auth State Controller using StreamBuilder for real-time state management
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFFF2E63)));
              }
              return snapshot.hasData ? const HomeScreen() : const LoginScreen();
            },
          ),

          // Draggable UI Layer for Global AI Assistant (The Floating Mic)
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

  /// Builds the interactive AI Floating Action Button with Reelzo Branding
  Widget _buildMiniAIButton({double opacity = 1.0}) {
    return Material(
      elevation: 12,
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          onTap: () {
            VoiceAIService.speak("Hi Hoonab, I am Reelzo AI. Your payment alerts are active. How can I assist you today?");
          },
          child: Container(
            width: 52, // Slightly increased for better touch accessibility
            height: 52,
            decoration: const BoxDecoration(
              gradient: reelzoGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: 15, spreadRadius: 3)
              ],
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}