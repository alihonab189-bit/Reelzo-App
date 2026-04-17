/// ===============================
/// FILE: lib/services/call_service.dart
/// ===============================
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CallService {
  static final _db = FirebaseFirestore.instance;
  static final stt.SpeechToText _speech = stt.SpeechToText();

  /// 📞 Start Call
  static Future<void> startCall({
    required String callerId,
    required String receiverId,
    required bool isVideo,
  }) async {
    String callId = DateTime.now().millisecondsSinceEpoch.toString();

    await _db.collection("calls").doc(callId).set({
      "callId": callId,
      "callerId": callerId,
      "receiverId": receiverId,
      "isVideo": isVideo,
      "status": "calling",
      "time": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ Accept Call
  static Future<void> acceptCall(String callId) async {
    await _db.collection("calls").doc(callId).update({
      "status": "accepted",
    });
  }

  /// ❌ End Call
  static Future<void> endCall(String callId) async {
    await _db.collection("calls").doc(callId).update({
      "status": "ended",
    });
  }

  /// 📡 Listen Call
  static Stream<DocumentSnapshot> listenCall(String callId) {
    return _db.collection("calls").doc(callId).snapshots();
  }

  /// 🎤 Listen (Voice Recognition for AI Assistant)
  static Future<String> listen() async {
    bool available = await _speech.initialize();
    String recognizedText = "";

    if (available) {
      await _speech.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
      );
      
      // Wait for speech to finish (adjust duration as needed)
      await Future.delayed(const Duration(seconds: 5));
      await _speech.stop();
    }
    
    return recognizedText;
  }
}