import 'dart:convert';
import 'package:http/http.dart' as http;

class AIModerationService {

static const String apiKey =
 String.fromEnvironment('OPENAI_API_KEY');

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