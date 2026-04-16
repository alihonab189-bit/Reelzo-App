/// ===============================
/// FILE: lib/services/storage_service.dart
/// ===============================
library;

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
final FirebaseStorage _storage = FirebaseStorage.instance;

/// Upload file to Firebase Storage
Future<String> uploadFile(File file, String path) async {
final ref = _storage.ref().child(path);
await ref.putFile(file);
return await ref.getDownloadURL();
}
}