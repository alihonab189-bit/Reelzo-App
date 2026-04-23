/// ===============================
/// FILE: lib/screens/home_screen.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import 'reel_screen.dart';
import 'shop_screen.dart';
import 'market_screen.dart';
import 'ai_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int _selectedIndex = 0;

final List<Widget> _pages = [
const ReelScreen(),
const ShopScreen(),
const MarketScreen(),
const AiScreen(),
const ProfileScreen(),
];

void _onItemTapped(int index) {
setState(() {
_selectedIndex = index;
});
}

// 🔥 APPBAR
PreferredSizeWidget _buildAppBar() {
return AppBar(
backgroundColor: Colors.black,
elevation: 0,
title: const Text(
"REELZO",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
actions: [
IconButton(
icon: const Icon(Icons.search, color: Colors.white),
onPressed: () {
// 🔥 TODO: Search functionality
},
),
IconButton(
icon: const Icon(Icons.notifications, color: Colors.white),
onPressed: () {
// 🔥 TODO: Notification screen
},
),
IconButton(
icon: const Icon(Icons.person, color: Colors.white),
onPressed: () {
// 🔥 TODO: Profile screen
},
),
],
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
appBar: _buildAppBar(),
body: _pages[_selectedIndex],
bottomNavigationBar: BottomNavigationBar(
backgroundColor: Colors.black,
selectedItemColor: Colors.pinkAccent,
unselectedItemColor: Colors.white60,
currentIndex: _selectedIndex,
onTap: _onItemTapped,
type: BottomNavigationBarType.fixed,
items: const [
BottomNavigationBarItem(
icon: Icon(Icons.video_library),
label: 'Reels',
),
BottomNavigationBarItem(
icon: Icon(Icons.shopping_cart),
label: 'Shop',
),
BottomNavigationBarItem(
icon: Icon(Icons.store),
label: 'Market',
),
BottomNavigationBarItem(
icon: Icon(Icons.smart_toy),
label: 'AI',
),
BottomNavigationBarItem(
icon: Icon(Icons.person),
label: 'Profile',
),
],
),
);
}
}