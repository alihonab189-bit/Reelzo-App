import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
const SettingScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,

  appBar: AppBar(
    backgroundColor: Colors.black,
    title: const Text("Settings"),
  ),

  body: ListView(
    children: [

      ListTile(
        title: const Text("Privacy", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),

      ListTile(
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),

      ListTile(
        title: const Text("Change Password", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),

      ListTile(
        title: const Text("Logout", style: TextStyle(color: Colors.red)),
        onTap: () {},
      ),

    ],
  ),
);

}
}