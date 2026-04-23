import 'package:flutter_tts/flutter_tts.dart';

class AIVoiceService {
static final FlutterTts _tts = FlutterTts();

static Future speak(String text) async {
await _tts.setLanguage("en-US");
await _tts.setPitch(1.0);
await _tts.speak(text);
}
}