/// ===============================
/// FILE: lib/services/real_ai_service.dart
/// ===============================
library;

import 'dart:convert';
import 'package:http/http.dart' as http;

class RealAIService {
  // Safe way to get API key
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  static Future<String> _callOpenAI(String systemPrompt, String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": systemPrompt
            },
            {
              "role": "user", 
              "content": userMessage
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Error: API returned status ${response.statusCode}";
      }
    } catch (e) {
      return "Error: Could not connect to AI service.";
    }
  }

  /// Standard Chat Mode
  static Future<String> chat(String message) async {
    return await _callOpenAI("You are a helpful assistant.", message);
  }

  /// AI Romantic Girlfriend Mode
  static Future<String> girlfriend(String message) async {
    const String systemPrompt = "You are a romantic girlfriend. Reply sweet, emotional.";
    return await _callOpenAI(systemPrompt, message);
  }

  /// AI Romantic Boyfriend Mode
  static Future<String> boyfriend(String message) async {
    const String systemPrompt = "You are a protective, charming, and romantic AI boyfriend. Your tone is supportive, slightly flirty, and very respectful. Use emojis.";
    return await _callOpenAI(systemPrompt, message);
  }
}