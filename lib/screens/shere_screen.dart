/// ===============================
/// FILE: lib/screens/shere_screen.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class ShereScreen extends StatelessWidget {
final File file;

const ShereScreen({super.key, required this.file});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Share")),
body: Center(
child: ElevatedButton.icon(
icon: const Icon(Icons.share),
label: const Text("Share Now"),
onPressed: () {
Share.shareXFiles([XFile(file.path)]);
},
),
),
);
}
}