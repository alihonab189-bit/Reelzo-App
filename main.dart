import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/upload_service.dart'; 
import 'services/voice_ai_service.dart'; 

LinearGradient reelzoGradient = const LinearGradient(
  colors: [Color(0xFFFF2E63), Color(0xFF7F00FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase Initialize
  await Firebase.initializeApp();

  // Custom Error Handling logic
  FlutterError.onError = (details) {
    print("Error: ${details.exception}");
  };

  // Background Services
  UploadService.autoUpload("user1");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reelzo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF2E63),
          secondary: Color(0xFF7F00FF),
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
  Offset position = const Offset(20, 200); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Authentication check
          AuthService.currentUser == null ? const LoginScreen() : const HomeScreen(),

          // Draggable AI Floating Button
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              feedback: _buildMiniAIButton(opacity: 0.5),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
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

  Widget _buildMiniAIButton({double opacity = 1.0}) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          onTap: () {
            VoiceAIService.speak("Hi, I am Reelzo AI. How can I help you?");
          },
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              gradient: reelzoGradient,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 14),
          ),
        ),
      ),
    );
  }
}