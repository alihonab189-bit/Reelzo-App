import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
static final _db = FirebaseFirestore.instance;

/// 🧾 CREATE ORDER
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

/// 🔄 UPDATE STATUS (ADMIN)
static Future<void> updateStatus(String orderId, String status) async {
await _db.collection("orders").doc(orderId).update({
"status": status,
});
}

/// 📦 USER ORDERS
static Stream<QuerySnapshot> getUserOrders(String userId) {
return _db
.collection("orders")
.where("userId", isEqualTo: userId)
.snapshots();
}
}