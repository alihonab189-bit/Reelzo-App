/// ===============================
/// FILE: lib/services/voice_ai_service.dart
/// ===============================
library;

import 'package:flutter_tts/flutter_tts.dart';
import 'real_ai_service.dart';

class VoiceAIService {
  static final FlutterTts _tts = FlutterTts();

  /// 🤖 AI + VOICE: Gets reply from AI and speaks it
  static Future<void> speak(String message) async {
    try {
      // 1. Get reply from RealAIService (OpenAI)
      String reply = await RealAIService.chat(message);

      // 2. TTS Configuration
      await _tts.setLanguage("en-US");
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.5); // Normal speaking speed

      // 3. Speak the AI reply
      await _tts.speak(reply);
    } catch (e) {
      print("Voice AI Error: $e");
    }
  }

  /// 🔊 SIMPLE SPEAK: Speaks direct text without AI reply
  static Future<void> speakDirect(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.speak(text);
  }
}