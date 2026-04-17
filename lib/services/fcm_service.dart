/// ===============================
/// FILE: lib/services/fcm_service.dart
/// ===============================
library;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {

static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

/// 🔔 INIT
static Future<void> init(BuildContext context) async {

// 🔑 Permission
await _fcm.requestPermission();

// 📱 Get Token
String? token = await _fcm.getToken();
print("FCM TOKEN: $token");

// 📩 Foreground message
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  if (message.notification != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.notification!.title ?? "Notification"),
      ),
    );
  }
});

// 📲 Click notification
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  print("Notification clicked");
});

}
}