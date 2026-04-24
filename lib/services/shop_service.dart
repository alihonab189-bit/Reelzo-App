import 'package:cloud_firestore/cloud_firestore.dart';

class ShopService {
static final _db = FirebaseFirestore.instance;

/// 🛍 Add product (ADMIN)
static Future<void> addProduct({
required String name,
required double price,
required List<String> images,
}) async {
await _db.collection("shop_products").add({
"name": name,
"price": price,
"images": images,
"createdAt": FieldValue.serverTimestamp(),
});
}

/// 📦 Get products
static Stream<QuerySnapshot> getProducts() {
return _db.collection("shop_products").snapshots();
}

/// 🧾 Order product
static Future<void> orderProduct({
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
"status": "pending",
"time": FieldValue.serverTimestamp(),
});
}
}