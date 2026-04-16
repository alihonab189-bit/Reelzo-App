import 'dart:convert';
import 'package:http/http.dart' as http;
import 'relationship_service.dart';

class AIChatService {

static const apiKey = "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";

static Future<String> sendMessage({
required String userId,
required String message,
}) async {

/// 📖 Load memory
var memory = await RelationshipService.getMemory(userId);

/// ❤️ Prompt (emotion)
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
  
  final data = jsonDecode(res.body);
  
  String reply = data["choices"][0]["message"]["content"];
  
  /// 💾 Save memory
  await RelationshipService.saveMemory(userId, message);
  
  return reply;
  }
  }