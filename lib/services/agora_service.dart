/// ===============================
/// FILE: lib/services/agora_service.dart
/// ===============================
library;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  // Fetching Agora App ID safely from environment variables
  static const String appId = String.fromEnvironment('AGORA_APP_ID');

  static Future<RtcEngine> initEngine() async {
    final engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(appId: appId));
    return engine;
  }
}