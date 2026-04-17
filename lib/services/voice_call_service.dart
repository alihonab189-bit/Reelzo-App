/// ===============================
/// FILE: lib/services/voice_call_service.dart
/// ===============================
library;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'agora_service.dart';

class VoiceCallService {

static Future<RtcEngine> start(String channel) async {

final engine = await AgoraService.initEngine();

await engine.enableAudio();

await engine.joinChannel(
  token: "",
  channelId: channel,
  uid: 0,
  options: const ChannelMediaOptions(),
);

return engine;

}

static Future<void> end(RtcEngine engine) async {
await engine.leaveChannel();
await engine.release();
}
}