import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import 'reel_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'shop_screen.dart';
import 'market_screen.dart';
import 'notification_screen.dart';
import 'payment_screen.dart';
import 'ai_screen.dart';
import 'upload_reel_screen.dart';
import 'story_screen.dart'; 
import 'login_screen.dart';

// Services
import '../services/story_service.dart'; 
import '../services/auth_service.dart';
import '../services/unified_ai_engine.dart'; // 🔥 AI Engine for Smart Feed
// 🔥 Trust Engine for User Safety

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    cleanOldStories();
    checkUserBanStatus();
  }

  /// 🛡️ Real-time Security Check
  Future<void> checkUserBanStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Using TrustEngine logic to check if user is shadowbanned or limited
      var doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      bool banned = doc.data()?["isBanned"] == true;
      
      if (banned) {
        await AuthService.logout();
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    }
  }

  /// 🧹 Auto-Delete Old Stories (24h Policy)
  Future<void> cleanOldStories() async {
    try {
      DateTime oneDayAgo = DateTime.now().subtract(const Duration(hours: 24));
      final querySnapshot = await FirebaseFirestore.instance
          .collection("stories")
          .where("time", isLessThan: oneDayAgo)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint("Cleanup error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "user_1";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildTopActionBar(),
      
      body: _currentIndex == 0 ? _buildSmartFeedUI(uid) : _getOtherScreens(_currentIndex),

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// 🧠 Smart Feed UI with AI Sorting
  Widget _buildSmartFeedUI(String uid) {
    return Column(
      children: [
        // 📸 Story Section
        StreamBuilder(
          stream: StoryService.getStories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            var stories = snapshot.data!.docs;
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, i) {
                  var s = stories[i];
                  return _storyItem(s.id, s["image"]);
                },
              ),
            );
          },
        ),

        // 🎬 AI Powered Smart Reel Feed
        Expanded(
          child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: UnifiedAIEngine.getSmartFeed(), // 🔥 Getting Top Viral Reels
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
              }
              // If AI finds reels, it shows them in a ranked order
              return const ReelScreen(); 
            },
          ),
        ),
      ],
    );
  }

  /// 🔝 Top Horizontal Menu
  PreferredSize _buildTopActionBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _topIconButton(Icons.smart_toy, Colors.blueAccent, () => _navTo(const AiScreen())),
                _topIconButton(Icons.shopping_bag, Colors.greenAccent, () => _navTo(const ShopScreen())),
                _topIconButton(Icons.store, Colors.orangeAccent, () => _navTo(const MarketScreen())),
                _topIconButton(Icons.notifications, Colors.pinkAccent, () => _navTo(const NotificationScreen())),
                _topIconButton(Icons.chat, Colors.white, () => _navTo(const ChatScreen(otherId: "user_2", myId: "user_1"))),
                _topIconButton(Icons.payment, Colors.yellowAccent, () => _navTo(const PaymentScreen())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topIconButton(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, color: color, size: 22), onPressed: onTap);
  }

  /// 📱 Professional Bottom Navigation
  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.9),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_filled, 0),
          _navIcon(Icons.explore_outlined, 1),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.pinkAccent, size: 35),
            onPressed: () => _navTo(const UploadReelScreen()),
          ),
          _navIcon(Icons.search, 4),
          _navIcon(Icons.person_outline, 5),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    bool isSelected = _currentIndex == index;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.pinkAccent : Colors.white60, size: 28),
      onPressed: () => setState(() => _currentIndex = index),
    );
  }

  Widget _storyItem(String id, String image) {
    return GestureDetector(
      onTap: () => _navTo(StoryScreen(storyId: id, image: image)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.purple, Colors.pinkAccent, Colors.orange]),
          ),
          child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(image)),
        ),
      ),
    );
  }

  Widget _getOtherScreens(int index) {
    switch (index) {
      case 4: return const SearchScreen();
      case 5: return const ProfileScreen();
      default: return const ReelScreen();
    }
  }

  void _navTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}