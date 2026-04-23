import 'package:cloud_firestore/cloud_firestore.dart';

class RatingService {
  static final _db = FirebaseFirestore.instance;

  /// ⭐ Optimized Rating Method for Millions of Users
  /// Instead of calculating every time, we update the product document directly.
  static Future<void> submitRating({
    required String productId,
    required double newRating,
  }) async {
    final productRef = _db.collection("products").doc(productId);

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot productSnap = await transaction.get(productRef);

        if (!productSnap.exists) return;

        // Fetch current values or set defaults
        double currentTotalRating = (productSnap.get("sumOfRatings") ?? 0).toDouble();
        int currentCount = productSnap.get("totalReviews") ?? 0;

        // Update with new values
        double updatedSum = currentTotalRating + newRating;
        int updatedCount = currentCount + 1;
        double updatedAverage = updatedSum / updatedCount;

        // Write back to the same product document
        transaction.update(productRef, {
          "sumOfRatings": updatedSum,
          "totalReviews": updatedCount,
          "averageRating": double.parse(updatedAverage.toStringAsFixed(1)), // Keeps it like 4.5
        });
      });
      
      print("Rating updated successfully via Transaction ✅");
    } catch (e) {
      print("Transaction Failed: $e");
    }
  }

  /// ⭐ Instant Rating Fetch
  /// Extremely fast because it reads only 1 field from 1 document.
  static Future<double> getQuickRating(String productId) async {
    var snap = await _db.collection("products").doc(productId).get();
    return (snap.data()?["averageRating"] ?? 0).toDouble();
  }
}