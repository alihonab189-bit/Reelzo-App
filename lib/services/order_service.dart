import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;

  /// 🧾 CREATE ORDER
  /// Initialized with 'placed' status
  static Future<void> createOrder({
    required String userId,
    required String productId,
    required String address,
    required String phone,
  }) async {
    await _db.collection("orders").add({
      "userId": userId,
      "productId": productId,
      "address": address,
      "phone": phone,
      "status": "placed",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ❌ CANCEL ORDER
  /// Allows user to cancel an order before it is processed
  static Future<void> cancelOrder(String orderId) async {
    await _db.collection("orders").doc(orderId).update({
      "status": "cancelled",
      "cancelledAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔄 RETURN ORDER
  /// Initiates a return request for a delivered product
  static Future<void> returnOrder(String orderId) async {
    await _db.collection("orders").doc(orderId).update({
      "status": "return_requested",
      "returnRequestedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🛠️ UPDATE STATUS (ADMIN ONLY)
  /// To update status to: 'shipped', 'delivered', 'returned', etc.
  static Future<void> updateStatus(String orderId, String status) async {
    await _db.collection("orders").doc(orderId).update({
      "status": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 📦 GET USER ORDERS (REAL-TIME)
  /// Fetches all orders placed by a specific user
  static Stream<QuerySnapshot> getUserOrders(String userId) {
    return _db
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true) // Newest orders first
        .snapshots();
  }
}