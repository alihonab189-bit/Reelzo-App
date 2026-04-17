/// ===============================
/// FILE: lib/screens/earnings_screen.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import '../services/earnings_service.dart';

class EarningsScreen extends StatelessWidget {
const EarningsScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Earnings")),
body: Center(
child: StreamBuilder<double>(
stream: EarningsService.getTotalEarnings(),
builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Text(
          "₹ ${snapshot.data!.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 30),
        );
      },
    ),
  ),
);

}
}