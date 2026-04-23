import 'package:flutter/material.dart';
import 'setting_screen.dart';
import 'chat_screen.dart';
// 🔥 Importing our logic services
import '../services/account_type_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Demo Data - Replace with your Firebase User Model
  String userId = "user1"; // Current Profile Owner ID
  String myId = "user1";   // My Logged-in ID (for testing)
  String accountType = "business"; // Fetch this from Firebase: private/public/business
  bool hasAccess = true;

  @override
  void initState() {
    super.initState();
    _checkPrivacy();
  }

  /// 🔒 Privacy Check for millions of users
  Future<void> _checkPrivacy() async {
    bool allowed = await AccountTypeService.canAccessContent(
      viewerId: myId,
      ownerId: userId,
    );
    setState(() => hasAccess = allowed);
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = (myId == userId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingScreen())),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            
            /// 👤 HEADER SECTION
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
            const SizedBox(height: 10),
            const Text("@username", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("🔥 Reelzo Creator | Entrepreneur", style: TextStyle(color: Colors.white54)),

            const SizedBox(height: 20),

            /// 📈 BUSINESS DASHBOARD (Only for Owner & Business Type)
            if (accountType == "business" && isOwner) _buildBusinessDashboard(),

            /// 📊 STATS BAR
            const _StatsBar(),

            const SizedBox(height: 20),

            /// 🛠️ ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900], foregroundColor: Colors.white),
                      child: const Text("Edit Profile"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!isOwner) // Message button only if not my profile
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen(myId: "user1", otherId: "user2"))),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white),
                        child: const Text("Message"),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🎬 CONTENT GRID OR PRIVACY SHIELD
            if (!hasAccess)
              _buildPrivateShield()
            else
              _buildContentGrid(),
          ],
        ),
      ),
    );
  }

  /// 💼 Professional Business Dashboard UI
  Widget _buildBusinessDashboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: Colors.blueAccent, size: 20),
              SizedBox(width: 10),
              Text("Business Analytics", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _analyticItem("Reach", "1.2M"),
              _analyticItem("Earnings", "₹45K"),
              _analyticItem("Followers", "+12%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analyticItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ],
    );
  }

  /// 🔒 Private Account Shield UI
  Widget _buildPrivateShield() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: const Column(
        children: [
          Icon(Icons.lock_outline, color: Colors.white24, size: 80),
          SizedBox(height: 10),
          Text("This Account is Private", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Follow to see their posts and reels", style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }

  /// 🎬 Post Grid
  Widget _buildContentGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 15,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
      itemBuilder: (context, i) => Image.network("https://picsum.photos/200?random=$i", fit: BoxFit.cover),
    );
  }
}

/// 📊 Stats Bar Widget
class _StatsBar extends StatelessWidget {
  const _StatsBar();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stat("120", "Posts"),
        _stat("5.2K", "Followers"),
        _stat("340", "Following"),
      ],
    );
  }
  static Widget _stat(String val, String label) => Column(children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ]);
}