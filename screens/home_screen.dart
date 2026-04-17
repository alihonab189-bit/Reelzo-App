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
import 'camera_screen.dart';
import 'story_screen.dart'; 
import 'login_screen.dart';

// Services
import '../services/story_service.dart'; 
import '../services/auth_service.dart';

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

  Future<void> checkUserBanStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool banned = await isBanned(user.uid);
      if (banned) {
        await AuthService.logout();
        if (!mounted) return;
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const LoginScreen())
        );
      }
    }
  }

  Future<bool> isBanned(String uid) async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.data()?["banned"] == true;
  }

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
      debugPrint("Error cleaning old stories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.smart_toy, color: Colors.white), onPressed: () => _navTo(const AiScreen())),
                  IconButton(icon: const Icon(Icons.shopping_bag, color: Colors.white), onPressed: () => _navTo(const ShopScreen())),
                  IconButton(icon: const Icon(Icons.store, color: Colors.white), onPressed: () => _navTo(const MarketScreen())),
                  IconButton(icon: const Icon(Icons.music_note, color: Colors.white), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () => _navTo(const NotificationScreen())),
                  IconButton(icon: const Icon(Icons.chat, color: Colors.white), onPressed: () => _navTo(const ChatScreen(otherId: "user_2", myId: "user_1"))),
                  IconButton(icon: const Icon(Icons.payment, color: Colors.white), onPressed: () => _navTo(const PaymentScreen())),
                ],
              ),
            ),
          ),
        ),
      ),

      // 🔥 Updated Body with Ban Check logic
      body: FutureBuilder<bool>(
        future: isBanned(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If banned, show the restricted message
          if (snapshot.data == true) {
            return const Center(
              child: Text(
                "You are banned 🚫",
                style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            );
          }

          // If not banned, show normal UI
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 10) { 
                _navTo(const CameraScreen());
              }
            },
            child: _currentIndex == 0 
              ? Column(
                  children: [
                    StreamBuilder(
                      stream: StoryService.getStories(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();
                        var stories = snapshot.data!.docs;
                        return SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: stories.length,
                            itemBuilder: (context, i) {
                              var s = stories[i];
                              return GestureDetector(
                                onTap: () => _navTo(StoryScreen(storyId: s.id, image: s["image"])),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.purpleAccent, width: 2),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(s["image"]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const Expanded(child: ReelScreen()), 
                  ],
                )
              : _getOtherScreens(_currentIndex), 
          );
        },
      ),

      bottomNavigationBar: Container(
        height: 65,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 0),
            _bottomNavItem(Icons.newspaper, 1),
            _bottomNavItem(Icons.video_library, 2),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.white, size: 30),
              onPressed: () => _navTo(const UploadReelScreen()),
            ),
            _bottomNavItem(Icons.search, 4),
            _bottomNavItem(Icons.person, 5), 
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon, color: _currentIndex == index ? Colors.purpleAccent : Colors.white),
      onPressed: () => setState(() => _currentIndex = index),
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