import 'dart:convert';
import 'package:http/http.dart' as http;
import 'relationship_service.dart';

class AIChatService {
  // Fetching the API Key safely from GitHub Secrets during build
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  static Future<String> sendMessage({
    required String userId,
    required String message,
  }) async {
    /// 📖 Load memory from database
    var memory = await RelationshipService.getMemory(userId);

    /// ❤️ AI Persona Prompt
    String prompt = """
You are a loving romantic partner.
You remember past conversations.

Memory:
$memory

User: $message

Reply like a real girlfriend/boyfriend:
- Emotional
- Caring
- Sometimes jealous
- Short natural reply
""";

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
            {"role": "user", "content": prompt}
          ]
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        String reply = data["choices"][0]["message"]["content"];

        /// 💾 Save conversation to memory
        await RelationshipService.saveMemory(userId, message);

        return reply;
      } else {
        return "Sorry dear, I'm a bit busy right now. Talk to you later!";
      }
    } catch (e) {
      return "Connection error. Please try again later.";
    }
  }
}