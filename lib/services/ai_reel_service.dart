import 'dart:convert';
import 'package:http/http.dart' as http;

class AIReelService {
  static const String apiKey =
   String.fromEnvironment('OPENAI_API_KEY');

  /// 🎬 Generate Reel Idea + Caption (Added userId parameter)
  static Future<Map<String, String>> generateReel(String userId) async {
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "user",
              "content": "Give viral reel idea + caption + hashtags for user: $userId"
            }
          ]
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        String text = data["choices"][0]["message"]["content"];
        return {
          "content": text,
        };
      } else {
        return {"content": "Error: Unable to generate idea."};
      }
    } catch (e) {
      return {"content": "Exception: $e"};
    }
  }
}