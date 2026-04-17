/// ===============================
/// FILE: lib/services/save_service.dart
/// ===============================
library;

import 'dart:io';
import 'package:gal/gal.dart';

class SaveService {
/// Save file to device gallery
Future<void> saveFile(File file) async {
await Gal.putVideo(file.path);
}
}