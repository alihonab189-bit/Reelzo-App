/// ===============================
/// FILE: lib/services/ai_video_service.dart
/// ===============================
library;

import 'dart:convert';
import 'package:http/http.dart' as http;

class AIVideoService {

static const String apiKey = "YOUR_DID_API_KEY";

/// 🎬 CREATE TALKING VIDEO
static Future<String?> createVideo(String text) async {

final response = await http.post(
  Uri.parse("https://api.d-id.com/talks"),
  headers: {
    "Authorization": "Basic $apiKey",
    "Content-Type": "application/json"
  },
  body: jsonEncode({
    "script": {
      "type": "text",
      "input": text
    },
    "source_url": "https://i.imgur.com/0y0y0y0.png"
  }),
);

if (response.statusCode == 201) {
  final data = jsonDecode(response.body);
  return data["id"]; // video id
}

return null;

}
}