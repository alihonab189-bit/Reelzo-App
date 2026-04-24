import 'package:cloud_firestore/cloud_firestore.dart';

class AccountTypeService {
  static final _db = FirebaseFirestore.instance;

  /// 🔄 CONFIGURE ACCOUNT PRIVACY
  /// Sets account as: 'public', 'private', or 'business'
  static Future<void> updateAccountType(String userId, String type) async {
    await _db.collection("users").doc(userId).set({
      "accountType": type,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 📥 FETCH ACCOUNT TYPE
  static Future<String> getAccountType(String userId) async {
    var doc = await _db.collection("users").doc(userId).get();
    return doc.data()?["accountType"] ?? "public";
  }

  /// 🔒 INTELLIGENT PRIVACY CHECK
  /// Determines if a viewer can access the user's content
  static Future<bool> canAccessContent({
    required String viewerId,
    required String ownerId,
  }) async {
    // 1. If viewer is the owner, always allow access
    if (viewerId == ownerId) return true;

    var doc = await _db.collection("users").doc(ownerId).get();
    if (!doc.exists) return true; // Default to public if user not found

    String type = doc.data()?["accountType"] ?? "public";

    // 2. Public & Business accounts are always accessible
    if (type == "public" || type == "business") return true;

    // 3. For Private accounts, check the followers sub-collection
    if (type == "private") {
      var followDoc = await _db
          .collection("followers")
          .doc(ownerId)
          .collection("user_followers") // Corrected sub-collection name
          .doc(viewerId)
          .get();

      return followDoc.exists;
    }

    return true;
  }
}