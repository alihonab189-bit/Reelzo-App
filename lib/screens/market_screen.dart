import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/shop_service.dart';
import '../services/order_service.dart';
// 🔥 New Optimized Rating Service
import '../widgets/delete_button.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matching your Reelzo theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Reelzo Market", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ShopService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products available", style: TextStyle(color: Colors.white54)));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, i) {
              var data = docs[i].data() as Map<String, dynamic>;
              String docId = docs[i].id;
              
              // Advanced Scalable Rating Data
              double rating = (data["averageRating"] ?? 0.0).toDouble();
              int totalReviews = data["totalReviews"] ?? 0;

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(data["name"] ?? "Premium Product", 
                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text("Price: ₹${data["price"]}", style: const TextStyle(color: Colors.pinkAccent, fontSize: 16)),
                            const SizedBox(height: 5),
                            // ⭐ Optimized Rating View
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text("$rating ($totalReviews reviews)", style: const TextStyle(color: Colors.white60, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        trailing: DeleteButton(collection: "market", docId: docId),
                      ),
                      
                      const Divider(color: Colors.white10),

                      /// 🎮 Order & Action Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 1. BUY BUTTON
                          _actionButton(
                            label: "Buy Now",
                            icon: Icons.shopping_cart,
                            color: Colors.green,
                            onTap: () {
                              OrderService.createOrder(
                                userId: "user1",
                                productId: docId,
                                address: "demo address",
                                phone: "9999999999",
                              );
                              _showMsg(context, "Order placed successfully! ✅");
                            },
                          ),

                          // 2. CANCEL BUTTON
                          _actionButton(
                            label: "Cancel ❌",
                            icon: Icons.close,
                            color: Colors.redAccent,
                            onTap: () async {
                              await OrderService.cancelOrder(docId);
                              _showMsg(context, "Order Cancelled! ❌");
                            },
                          ),

                          // 3. RETURN BUTTON
                          _actionButton(
                            label: "Return 🔄",
                            icon: Icons.keyboard_return,
                            color: Colors.blueAccent,
                            onTap: () async {
                              await OrderService.returnOrder(docId);
                              _showMsg(context, "Return request sent! 🔄");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 🛠️ Custom Reusable Button Widget
  Widget _actionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.grey[800]));
  }
}