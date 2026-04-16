import 'dart:convert';
import 'package:http/http.dart' as http;

class AIModerationService {

static const apiKey = "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";

static Future<bool> isBad(String text) async {

final res = await http.post(
  Uri.parse("https://api.openai.com/v1/moderations"),
  headers: {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json"
  },
  body: jsonEncode({
    "input": text
  }),
);

final data = jsonDecode(res.body);

bool flagged = data["results"][0]["flagged"];
return flagged;

}
}