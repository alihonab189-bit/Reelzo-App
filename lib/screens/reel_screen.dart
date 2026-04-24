import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/algorithm_service.dart';
import '../services/ad_service.dart';
import '../models/ad_model.dart';
import '../models/feed_item_model.dart';
import 'live_screen.dart';
import '../widgets/delete_button.dart';
// 🔥 Importing our Advanced AI & Privacy Services
import '../services/unified_ai_engine.dart';
import '../services/trust_engine.dart';
import '../services/account_type_service.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final Map<int, VideoPlayerController> _controllers = {};
  List<FeedItem> combinedFeed = [];
  bool isFeedGenerated = false;
  String myId = "user1"; // Replace with your actual Logged-in Auth ID

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void generateFeed(List<dynamic> reels, List<AdModel> ads) {
    combinedFeed.clear();
    int adIndex = 0;
    for (int i = 0; i < reels.length; i++) {
      combinedFeed.add(FeedItem(
        id: reels[i].id,
        title: reels[i]["userName"] ?? "User",
        description: reels[i]["caption"] ?? "",
        url: reels[i]["video"],
        isAd: false,
        ownerId: reels[i]["userId"] ?? "", // Storing owner ID for privacy check
      ));

      if ((i + 1) % 15 == 0 && ads.isNotEmpty) { // Ads every 15 reels for better revenue
        var currentAd = ads[adIndex % ads.length];
        combinedFeed.add(FeedItem(
          id: currentAd.id,
          title: currentAd.title,
          description: currentAd.description,
          url: currentAd.imageUrl,
          isAd: true,
          link: currentAd.link,
          ownerId: "admin",
        ));
        adIndex++;
      }
    }
    isFeedGenerated = true;
  }

  Widget buildFeedUI(FeedItem item, int index) {
    if (item.isAd) {
      return buildAdUI(item);
    } else {
      return FutureBuilder<bool>(
        // 🔒 Privacy Check before showing the Reel
        future: AccountTypeService.canAccessContent(viewerId: myId, ownerId: item.ownerId ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox();
          if (snapshot.data == false) return _buildPrivateVideoShield();
          
          return buildVideo(item.url, index, item.id, item.title, item.description, item.ownerId ?? "");
        },
      );
    }
  }

  Widget _buildPrivateVideoShield() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, color: Colors.pinkAccent, size: 60),
            SizedBox(height: 10),
            Text("Private Video", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Follow the user to watch this reel", style: TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget buildVideo(String url, int index, String reelId, String userName, String caption, String ownerId) {
    if (!_controllers.containsKey(index)) {
      _controllers[index] = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {});
          // 🧠 AI Behavioral Learning on Video Play
          UnifiedAIEngine.run(
            userId: ownerId, 
            postId: reelId, 
            text: caption, 
            data: {"views": 1} // Incrementing view on play
          );
        })
        ..setLooping(true)
        ..play();
    }

    final controller = _controllers[index]!;

    return Stack(
      children: [
        SizedBox.expand(
          child: controller.value.isInitialized
              ? FittedBox(fit: BoxFit.cover, child: SizedBox(width: controller.value.size.width, height: controller.value.size.height, child: VideoPlayer(controller)))
              : const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
        ),
        _sideActionBar(reelId, false, ownerId),
        _bottomInfoBar(userName, caption, false, null, ownerId),
      ],
    );
  }

  Widget _sideActionBar(String id, bool isAd, String ownerId) {
    return Positioned(
      right: 15,
      bottom: 100,
      child: Column(
        children: [
          _buildProfileIcon(ownerId),
          const SizedBox(height: 20),
          _sideButton(Icons.favorite, Colors.white, () {
            if (!isAd) {
              AlgorithmService.likeReel(id);
              // ⭐ Trust Engine Update
              TrustEngine.run(userId: ownerId, contentData: {"likes": 1}, likes: 1, reports: 0);
            }
          }),
          _actionLabel("Like"),
          const SizedBox(height: 15),
          _sideButton(Icons.comment, Colors.white, () {}),
          _actionLabel("Comment"),
          const SizedBox(height: 15),
          _sideButton(Icons.share, Colors.white, () {}),
          _actionLabel("Share"),
          
          if (!isAd && ownerId == myId) ...[
            const SizedBox(height: 15),
            DeleteButton(collection: "reels", docId: id),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileIcon(String ownerId) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveScreen())),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(radius: 25, backgroundColor: Colors.white, child: CircleAvatar(radius: 23, backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          Positioned(bottom: -5, child: Container(decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.add, color: Colors.white, size: 15))),
        ],
      ),
    );
  }

  Widget _actionLabel(String label) {
    return Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold));
  }

  Widget _bottomInfoBar(String title, String desc, bool isAd, String? link, String ownerId) {
    return Positioned(
      left: 15,
      bottom: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("@$title", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 10),
              // 🏆 Badge system logic
              const Icon(Icons.verified, color: Colors.blueAccent, size: 16),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(width: MediaQuery.of(context).size.width * 0.7, child: Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 14), maxLines: 2)),
          const SizedBox(height: 10),
          // 💰 Earning Tip (Dynamic AI Suggestion)
          if (ownerId == myId) 
             Text(UnifiedAIEngine.getEarningTip({"views": 1200}), style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _sideButton(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, color: color, size: 30), onPressed: onTap);
  }

  Widget buildAdUI(FeedItem item) {
    return Stack(
      children: [
        SizedBox.expand(child: Image.network(item.url, fit: BoxFit.cover)),
        _sideActionBar(item.id, true, ""),
        _bottomInfoBar(item.title, item.description, true, item.link, ""),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: AlgorithmService.getReels(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
          final reels = snapshot.data!.docs;
          if (reels.isEmpty) return const Center(child: Text("No reels yet", style: TextStyle(color: Colors.white)));

          final ads = AdService().getAds();
          if (!isFeedGenerated) generateFeed(reels, ads);

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: combinedFeed.length,
            itemBuilder: (context, index) => buildFeedUI(combinedFeed[index], index),
          );
        },
      ),
    );
  }
}