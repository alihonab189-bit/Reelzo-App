import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/algorithm_service.dart';
import '../services/ad_service.dart';
import '../models/ad_model.dart';
import '../models/feed_item_model.dart';
import 'live_screen.dart';
// 1. Importing the Custom Delete Button Widget
import '../widgets/delete_button.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final Map<int, VideoPlayerController> _controllers = {};
  List<FeedItem> combinedFeed = [];
  bool isFeedGenerated = false;

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
      ));

      if ((i + 1) % 20 == 0 && ads.isNotEmpty) {
        var currentAd = ads[adIndex % ads.length];
        combinedFeed.add(FeedItem(
          id: currentAd.id,
          title: currentAd.title,
          description: currentAd.description,
          url: currentAd.imageUrl,
          isAd: true,
          link: currentAd.link,
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
      return buildVideo(item.url, index, item.id, item.title, item.description);
    }
  }

  Widget buildAdUI(FeedItem item) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.network(item.url, fit: BoxFit.cover),
        ),
        _sideActionBar(item.id, true),
        _bottomInfoBar(item.title, item.description, true, item.link),
      ],
    );
  }

  Widget buildVideo(String url, int index, String reelId, String userName, String caption) {
    if (!_controllers.containsKey(index)) {
      _controllers[index] = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) => setState(() {}))
        ..setLooping(true)
        ..play();
    }

    final controller = _controllers[index]!;

    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
        _sideActionBar(reelId, false),
        _bottomInfoBar(userName, caption, false, null),
      ],
    );
  }

  // 2. Updated Side Action Bar with Delete Functionality
  Widget _sideActionBar(String id, bool isAd) {
    return Positioned(
      right: 10,
      bottom: 80,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveScreen())),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add, color: Colors.white, size: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _sideButton(Icons.live_tv, Colors.pinkAccent, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveScreen()));
          }),
          const SizedBox(height: 15),
          _sideButton(Icons.favorite, Colors.red, () {
            if (!isAd) AlgorithmService.likeReel(id);
          }),
          const SizedBox(height: 15),
          _sideButton(Icons.comment, Colors.white, () {}),
          const SizedBox(height: 15),
          _sideButton(Icons.share, Colors.white, () {}),
          const SizedBox(height: 15),
          _sideButton(Icons.bookmark, Colors.white, () {}),
          const SizedBox(height: 15),
          _sideButton(Icons.more_vert, Colors.white, () {}),
          
          // 3. Integration of DeleteButton (Only for non-ad content)
          if (!isAd) ...[
            const SizedBox(height: 15),
            DeleteButton(
              collection: "reels",
              docId: id,
            ),
          ],
          
          const SizedBox(height: 15),
          _sideButton(Icons.music_note, Colors.white, () {}),
        ],
      ),
    );
  }

  Widget _bottomInfoBar(String title, String desc, bool isAd, String? link) {
    return Positioned(
      left: 15,
      bottom: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(desc, style: const TextStyle(color: Colors.white70), maxLines: 2),
          ),
          if (isAd && link != null) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async => await launchUrl(Uri.parse(link)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child: const Text("Learn More", style: TextStyle(color: Colors.white)),
            ),
          ]
        ],
      ),
    );
  }

  Widget _sideButton(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, color: color), onPressed: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: AlgorithmService.getReels(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final reels = snapshot.data!.docs;
          if (reels.isEmpty) return const Center(child: Text("No reels yet", style: TextStyle(color: Colors.white)));

          final ads = AdService().getAds();

          if (!isFeedGenerated || combinedFeed.length != (reels.length + (reels.length ~/ 20))) {
            generateFeed(reels, ads);
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: combinedFeed.length,
            itemBuilder: (context, index) {
              return buildFeedUI(combinedFeed[index], index);
            },
          );
        },
      ),
    );
  }
}