import 'package:flutter/material.dart';
import '../services/shop_service.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. Importing the Custom Delete Button Widget
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Successful!")),
        );
      },
      error: (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Failed!")),
        );
      },
      external: (response) {},
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
      appBar: AppBar(title: const Text("Shop")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ShopService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              var data = docs[i].data() as Map<String, dynamic>;
              String docId = docs[i].id; // Extracting Document ID

              return ListTile(
                title: Text(data["name"] ?? "Product"),
                subtitle: Text("₹${data["price"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 2. Integration of DeleteButton for Shop items
                    DeleteButton(
                      collection: "market", // Use correct collection name in Firestore
                      docId: docId,
                    ),
                    const SizedBox(width: 8),
                    // New Payment Button
                    ElevatedButton(
                      onPressed: () {
                        _payment.openPayment(100); 
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Pay ₹100"),
                    ),
                    const SizedBox(width: 8),
                    // Buy Button
                    ElevatedButton(
                      onPressed: () {
                        OrderService.createOrder(
                          userId: userId,
                          productId: docId,
                          address: "demo address",
                          phone: "9999999999",
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Order placed successfully!")),
                        );
                      },
                      child: const Text("Buy"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}