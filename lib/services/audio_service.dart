/// ===============================
/// FILE: lib/services/audio_service.dart
/// ===============================
library;

import 'package:audioplayers/audioplayers.dart';

class AudioService {
final AudioPlayer _player = AudioPlayer();

/// Play audio from URL or local file
Future<void> play(String path) async {
await _player.play(UrlSource(path));
}

/// Pause audio
Future<void> pause() async {
await _player.pause();
}

/// Stop audio
Future<void> stop() async {
await _player.stop();
}
}