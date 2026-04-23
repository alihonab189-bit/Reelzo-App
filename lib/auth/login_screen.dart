// ===============================
// FILE: lib/auth/login_screen.dart
// ===============================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final email = TextEditingController();
  final pass = TextEditingController();

  // 🔐 LOGIN
  Future<void> login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text.trim(),
      password: pass.text.trim(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  // 🆕 SIGNUP
  Future<void> signup() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: pass.text.trim(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔥 APP NAME
            const Text("REELZO",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),

            // 📧 EMAIL
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: "Email"),
            ),

            const SizedBox(height: 10),

            // 🔑 PASSWORD
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
            ),

            const SizedBox(height: 20),

            // 🔓 LOGIN BTN
            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            ),

            // 🆕 SIGNUP BTN
            ElevatedButton(
              onPressed: signup,
              child: const Text("Signup"),
            ),
          ],
        ),
      ),
    );
  }
}