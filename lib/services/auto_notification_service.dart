/// ===============================
/// FILE: lib/services/auto_notification_service.dart
/// ===============================
library;

import 'dart:async';

class AutoNotificationService {

static void start() {

Timer.periodic(const Duration(hours: 3), (timer) {
  print("Send notification: New reel uploaded 🔥");
});

}
}