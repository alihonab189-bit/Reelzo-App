/// ===============================
/// FILE: lib/services/ai_service.dart
/// ===============================
library;

class AIService {
  /// 🚫 Basic moderation (AIModerationService logic)
  static Future<bool> isSafe(String text) async {
    List<String> bannedWords = [
      "abuse",
      "fake",
      "scam",
    ];

    for (var word in bannedWords) {
      if (text.toLowerCase().contains(word)) {
        return false;
      }
    }
    // Return true if no banned words are found
    return true;
  }

  /// 💬 Normal AI Chat (AIChatService logic)
  static Future<String> normal(String message) async {
    // You can integrate Gemini or OpenAI API here later
    // For now, it returns a placeholder response
    return "AI Response to: $message";
  }

  /// 🎬 Generate AI Reel (AIReelService logic)
  static Future<void> generateReel(String userId) async {
    // Logic for AI video generation or automated content creation
    print("Generating AI Reel for User: $userId");
  }
}