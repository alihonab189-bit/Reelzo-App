import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatelessWidget {
const OrderScreen({super.key});

@override
Widget build(BuildContext context) {
String userId = "user1";

return Scaffold(
  appBar: AppBar(title: const Text("My Orders")),
  body: StreamBuilder<QuerySnapshot>(
    stream: OrderService.getUserOrders(userId),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      var orders = snapshot.data!.docs;

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, i) {
          var data = orders[i];

          return ListTile(
            title: Text("Product: ${data["productId"]}"),
            subtitle: Text("Status: ${data["status"]}"),
          );
        },
      );
    },
  ),
);

}
}