import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../services/payment_service.dart'; 
// 🔥 Importing SuperAdminService for verification
import '../services/super_admin_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _payment = PaymentService();
  String userId = "user1"; 

  @override
  void initState() {
    super.initState();
    _payment.init(
      success: (response) async {
        print("Payment Gateway Success. Verifying with SuperAdmin...");

        // 🔥 Added Verification Logic
        double amount = 100.0;
        bool ok = await SuperAdminService.verifyPayment(amount);
        
        if (ok) {
          // Only add money if Admin verification is successful
          await WalletService.addMoney(userId, amount);
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment Verified & Wallet Updated!"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // If verification fails
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment Verification Failed! Contact Support."),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      error: (response) {
        print("Payment Failed");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Failed!")),
        );
      },
      external: (response) {
        print("External Wallet");
      },
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Reelzo Wallet"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: WalletService.getBalance(userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                var data = snapshot.data!.data() as Map<String, dynamic>?;
                double balance = (data != null && data.containsKey('balance')) 
                    ? data['balance'].toDouble() 
                    : 0.0;

                return Column(
                  children: [
                    const Text("Current Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(
                      "₹$balance",
                      style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 50),

            // Option 1: Simple Pay Button
            ElevatedButton(
              onPressed: () {
                _payment.openPayment(100); 
              },
              child: const Text("Pay ₹100"),
            ),

            const SizedBox(height: 20),

            // Option 2: Styled Add Money Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                _payment.openPayment(100); 
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add ₹100 via Razorpay", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            const SizedBox(height: 20),

            // Option 3: Send Money Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white12,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                WalletService.sendMoney(
                  from: userId,
                  to: "user2",
                  amount: 50,
                );
              },
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text("Send ₹50 to user2", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}