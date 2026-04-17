import 'package:flutter/material.dart';
import '../services/shop_service.dart';
import '../services/order_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. Importing the Custom Delete Button Widget
import '../widgets/delete_button.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

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
              String docId = docs[i].id; // Storing the Document ID

              return ListTile(
                title: Text(data["name"] ?? "Product"),
                subtitle: Text("₹${data["price"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 2. Integration of DeleteButton for Market/Shop items
                    DeleteButton(
                      collection: "market", 
                      docId: docId,
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        OrderService.createOrder(
                          userId: "user1",
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