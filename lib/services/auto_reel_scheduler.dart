/// ===============================
/// FILE: lib/services/auto_reel_scheduler.dart
/// ===============================
library;

import 'dart:async';
import 'ai_reel_service.dart';

class AutoReelScheduler {

static void start(String userId) {

Timer.periodic(const Duration(hours: 2), (timer) {
  AIReelService.generateReel(userId);
});

}
}