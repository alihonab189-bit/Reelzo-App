import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'ban_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final dynamic _googleSignIn = (GoogleSignIn as dynamic)(scopes: ['email']);

  /// Get Current User UID
  static String get uid => _auth.currentUser?.uid ?? "";

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

  /// ✅ Google Login (Error-free version)
  static Future<User?> signInWithGoogle() async {
    try {
      final dynamic googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final dynamic googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        bool banned = await BanService.isBanned(user.uid);
        if (banned) {
          await logout();
          throw Exception("banned");
        }
      }
      return user;
    } catch (e) {
      print("Google Auth Error: $e");
      return null;
    }
  }

  /// ✅ Logout
  static Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}