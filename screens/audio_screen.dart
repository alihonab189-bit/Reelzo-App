/// ===============================
/// FILE: lib/screens/audio_screen.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class AudioScreen extends StatefulWidget {
const AudioScreen({super.key});

@override
State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
final AudioService _audioService = AudioService();
bool _isPlaying = false;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Select Audio")),
body: ListView(
children: [
ListTile(
title: const Text("Background Music 1"),
trailing: IconButton(
icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
onPressed: () async {
if (_isPlaying) {
await _audioService.pause();
} else {
await _audioService.play("https://sample-videos.com/audio/mp3/wave.mp3");
}
setState(() => _isPlaying = !_isPlaying);
},
),
),
ListTile(
title: const Text("Background Music 2"),
trailing: IconButton(
icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
onPressed: () async {
if (_isPlaying) {
await _audioService.pause();
} else {
await _audioService.play("https://sample-videos.com/audio/mp3/crowd-cheering.mp3");
}
setState(() => _isPlaying = !_isPlaying);
},
),
),
],
),
);
}
}