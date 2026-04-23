class FeedItem {
  final String id;
  final String title;
  final String description;
  final String url; // Video URL or Image URL for Ads
  final bool isAd;
  final String? link; // Only for Ads
  final String ownerId;

  FeedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    this.isAd = false,
    this.link,
    required this.ownerId,
  });
}