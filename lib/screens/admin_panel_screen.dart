/// ===============================
/// FILE: lib/screens/admin_panel_screen.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatelessWidget {
const AdminPanelScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Admin Panel")),
body: StreamBuilder(
stream: FirebaseFirestore.instance
.collection("reports")
.orderBy("time", descending: true)
.snapshots(),
builder: (context, snapshot) {

      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final reports = snapshot.data!.docs;

      return ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {

          var data = reports[index];

          return ListTile(
            title: Text(data["type"]),
            subtitle: Text(data["reason"]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                data.reference.delete();
              },
            ),
          );
        },
      );
    },
  ),
);

}
}