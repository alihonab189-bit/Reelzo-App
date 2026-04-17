import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatelessWidget {
const ProfileScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,

  /// 🔝 APP BAR
  appBar: AppBar(
    backgroundColor: Colors.black,
    title: const Text("Profile"),
    actions: [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SettingScreen(),
            ),
          );
        },
      )
    ],
  ),

  body: SingleChildScrollView(
    child: Column(
      children: [

        const SizedBox(height: 20),

        /// 👤 PROFILE IMAGE
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            "https://i.pravatar.cc/150?img=3",
          ),
        ),

        const SizedBox(height: 10),

        /// 🧑 USERNAME
        const Text(
          "@username",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        /// ✍ BIO
        const Text(
          "🔥 Reelzo User | Creator",
          style: TextStyle(color: Colors.white70),
        ),

        const SizedBox(height: 20),

        /// 📊 STATS
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text("120", style: TextStyle(color: Colors.white)),
                Text("Posts", style: TextStyle(color: Colors.white54)),
              ],
            ),
            Column(
              children: [
                Text("5K", style: TextStyle(color: Colors.white)),
                Text("Followers", style: TextStyle(color: Colors.white54)),
              ],
            ),
            Column(
              children: [
                Text("300", style: TextStyle(color: Colors.white)),
                Text("Following", style: TextStyle(color: Colors.white54)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ✏️ EDIT BUTTON
        ElevatedButton(
          onPressed: () {},
          child: const Text("Edit Profile"),
        ),

        const SizedBox(height: 20),

        /// 💬 CHAT BUTTON
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChatScreen(
                  myId: "user1",
                  otherId: "user2",
                ),
              ),
            );
          },
          child: const Text("Message"),
        ),

        const SizedBox(height: 20),

        /// 🎬 USER POSTS GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return Image.network(
              "https://picsum.photos/200?random=$index",
              fit: BoxFit.cover,
            );
          },
        ),

      ],
    ),
  ),
);

}
}