/// ===============================
/// FILE: lib/services/auth_service.dart
/// ===============================
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'ban_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get Current User UID
  static String get uid => _auth.currentUser!.uid;

  /// Get Current User Object
  static User? get currentUser => _auth.currentUser;

  /// Anonymous Login
  static Future<User?> loginAnon() async {
    final res = await _auth.signInAnonymously();
    return res.user;
  }

  /// Email Sign Up
  static Future<User?> signUp(String email, String password) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  /// Email Login (With Ban Check)
  static Future<User?> login(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (res.user != null) {
      bool banned = await BanService.isBanned(res.user!.uid);
      if (banned) {
        await logout();
        throw Exception("banned");
      }
    }
    return res.user;
  }

  /// Google Login (With Ban Check)
  static Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final res = await _auth.signInWithCredential(credential);

    if (res.user != null) {
      bool banned = await BanService.isBanned(res.user!.uid);
      if (banned) {
        await logout();
        throw Exception("banned");
      }
    }
    return res.user;
  }

  /// Logout
  static Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}