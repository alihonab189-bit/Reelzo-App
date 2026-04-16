import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/ban_service.dart'; 
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLogin = true;

  void submit() async {
    try {
      if (isLogin) {
        await AuthService.login(
          emailController.text,
          passController.text,
        );
      } else {
        await AuthService.signUp(
          emailController.text,
          passController.text,
        );
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      bool banned = await BanService.isBanned(user.uid);

      if (banned) {
        await AuthService.logout(); 
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account Blocked! You have 3 strikes for bad behavior."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      String errorMsg = e.toString().contains("banned") 
          ? "This account is banned!" 
          : e.toString();
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView( // To avoid overflow on small screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                "Reelzo",
                style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
                child: Text(isLogin ? "Login" : "Sign Up"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => isLogin = !isLogin);
                },
                child: Text(
                  isLogin ? "Create account" : "Already have account",
                  style: const TextStyle(color: Colors.purpleAccent),
                ),
              ),
              const SizedBox(height: 20),
              
              /// 🔵 GOOGLE LOGIN BUTTON
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await AuthService.signInWithGoogle();
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;

                    bool banned = await BanService.isBanned(user.uid);

                    if (banned) {
                      await AuthService.logout();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Google account is banned!"), backgroundColor: Colors.red),
                      );
                    } else {
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()))
                    );
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text("Continue with Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
              
              const SizedBox(height: 10),

              /// 👤 ANONYMOUS / GUEST LOGIN BUTTON (New Added)
              TextButton.icon(
                onPressed: () async {
                  try {
                    await AuthService.loginAnon();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Guest Login Failed: $e"))
                    );
                  }
                },
                icon: const Icon(Icons.person_outline, color: Colors.grey),
                label: const Text("Continue as Guest", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}