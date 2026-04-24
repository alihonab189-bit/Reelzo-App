import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/shop_service.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import '../widgets/delete_button.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final PaymentService _payment = PaymentService();
  final String userId = "user1";

  @override
  void initState() {
    super.initState();
    _payment.init(
      success: (response) {
        _showMsg("Payment Successful! ✅", Colors.green);
      },
      error: (response) {
        _showMsg("Payment Failed! ❌", Colors.redAccent);
      },
      external: (response) {},
    );
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _payment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Reelzo Dark Theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Reelzo Official Shop", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ShopService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              var data = docs[i].data() as Map<String, dynamic>;
              String docId = docs[i].id;
              double price = (data["price"] ?? 0).toDouble();
              double rating = (data["averageRating"] ?? 0.0).toDouble();
              int reviews = data["totalReviews"] ?? 0;

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data["name"] ?? "Premium Item", 
                                     style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text("₹$price", style: const TextStyle(color: Colors.pinkAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          DeleteButton(collection: "market", docId: docId),
                        ],
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // ⭐ Smart Rating Display
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 5),
                          Text("$rating ($reviews Reviews)", style: const TextStyle(color: Colors.white60, fontSize: 13)),
                        ],
                      ),
                      
                      const Divider(color: Colors.white10, height: 25),

                      /// 🎮 Action Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Pay & Buy Action
                          _actionIcon(
                            label: "Pay & Buy",
                            icon: Icons.bolt,
                            color: Colors.green,
                            onTap: () {
                              _payment.openPayment(price.toDouble());
                              OrderService.createOrder(
                                userId: userId,
                                productId: docId,
                                address: "demo address",
                                phone: "9999999999",
                              );
                            },
                          ),

                          // Cancel Action
                          _actionIcon(
                            label: "Cancel ❌",
                            icon: Icons.cancel_outlined,
                            color: Colors.redAccent,
                            onTap: () async {
                              await OrderService.cancelOrder(docId);
                              _showMsg("Order Cancelled! ❌", Colors.redAccent);
                            },
                          ),

                          // Return Action
                          _actionIcon(
                            label: "Return 🔄",
                            icon: Icons.assignment_return_outlined,
                            color: Colors.blueAccent,
                            onTap: () async {
                              await OrderService.returnOrder(docId);
                              _showMsg("Return request initiated! 🔄", Colors.blueAccent);
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

  /// 🛠️ Custom Mini Action Button
  Widget _actionIcon({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}