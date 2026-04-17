import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Notifications")),
      body: const Center(
        child: Text("No notifications", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}