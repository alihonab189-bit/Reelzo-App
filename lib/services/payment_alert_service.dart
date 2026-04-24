import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentAlertService {
  // Singleton pattern for global access and performance
  static final PaymentAlertService _instance = PaymentAlertService._internal();
  factory PaymentAlertService() => _instance;
  PaymentAlertService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  static const String _storageKey = "REELZO_VOICE_ALERT_STATUS";

  /// Initialize TTS settings to handle audio focus and background playback
  Future<void> init() async {
    await _flutterTts.setSharedInstance(true);
    // This setting ensures voice alert doesn't stop other music completely, just lowers it (Ducking)
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.duckOthers
      ],
    );
  }

  /// Update the user's preference in high-speed local storage
  Future<void> updateAlertStatus(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, isEnabled);
  }

  /// Check if the user has voice alerts enabled
  Future<bool> getAlertStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_storageKey) ?? true; // Default is ON
  }

  /// Core logic to convert payment data into real-time speech
  Future<void> announcePayment({
    required double amount, 
    String currency = "Taka", 
    String languageCode = "bn-BD",
  }) async {
    
    bool isEnabled = await getAlertStatus();
    if (!isEnabled) return;

    // TTS Engine Configuration
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.setPitch(1.0); 
    await _flutterTts.setSpeechRate(0.5); 
    await _flutterTts.setVolume(1.0); // Maximum volume for soundbox effect

    String announcement;
    if (languageCode == "bn-BD") {
      announcement = "আপনার অ্যাকাউন্টে ${amount.toInt()} টাকা জমা হয়েছে।";
    } else {
      announcement = "Successful payment of ${amount.toInt()} $currency received.";
    }

    await _flutterTts.speak(announcement);
  }
}