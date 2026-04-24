import 'package:cloud_firestore/cloud_firestore.dart';

class MarketService {
static final _db = FirebaseFirestore.instance;

/// 🏪 User upload product
static Future<void> addProduct({
required String userId,
required String name,
required double price,
required List<String> images,
}) async {
await _db.collection("market_products").add({
"userId": userId,
"name": name,
"price": price,
"images": images,
"createdAt": FieldValue.serverTimestamp(),
});
}

/// 📦 Get market products
static Stream<QuerySnapshot> getProducts() {
return _db.collection("market_products").snapshots();
}

/// 💰 Order (1% commission)
static Future<void> orderProduct({
required String buyerId,
required String productId,
}) async {
await _db.collection("market_orders").add({
"buyerId": buyerId,
"productId": productId,
"commission": 0.01,
"status": "pending",
"time": FieldValue.serverTimestamp(),
});
}
}