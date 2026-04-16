/// ===============================
/// FILE: lib/services/agora_service.dart
/// ===============================
library;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {

static const String appId = "YOUR_AGORA_APP_ID"; // 🔥 replace

static Future<RtcEngine> initEngine() async {
final engine = createAgoraRtcEngine();
await engine.initialize(const RtcEngineContext(appId: appId));
return engine;
}
}