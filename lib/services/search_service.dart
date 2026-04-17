/// ===============================
/// FILE: lib/services/search_service.dart
/// ===============================
library;

class SearchService {

// 🔍 Dummy data (later Firebase use korben)
final List<String> users = [
"reel_master",
"gaming_pro",
"md_honab",
"tech_world",
];

final List<String> videos = [
"funny reel",
"gaming highlights",
"tech review",
"motivation video",
];

final List<String> products = [
"mobile phone",
"headphones",
"laptop",
"camera",
];

final List<String> hashtags = [
"#reelzo",
"#trending",
"#viral",
"#foryou",
];

// 🔍 SEARCH FUNCTION
List<String> search(String query) {
query = query.toLowerCase();

final results = [
  ...users,
  ...videos,
  ...products,
  ...hashtags,
];

return results
    .where((item) => item.toLowerCase().contains(query))
    .toList();

}
}