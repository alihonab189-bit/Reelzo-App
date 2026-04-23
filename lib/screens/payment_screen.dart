import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/wallet_service.dart';
import '../services/payment_service.dart'; 
import '../services/super_admin_service.dart'; 
import '../services/payment_alert_service.dart'; // 🔥 Global Voice Alert Service

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _payment = PaymentService();
  
  // Note: Replace "user1" with actual logged-in user ID in production
  String userId = "user1"; 

  @override
  void initState() {
    super.initState();
    _initializePaymentGateway();
  }

  /// Initialize Payment Gateway with Advanced Verification & Voice Alert
  void _initializePaymentGateway() {
    _payment.init(
      success: (response) async {
        debugPrint("Gateway Success. Initiating SuperAdmin Verification...");

        // Define amount (can be dynamic based on user selection)
        double amount = 100.0;

        // 1. Verify payment with backend/admin to prevent fraud
        bool isVerified = await SuperAdminService.verifyPayment(amount);
        
        if (isVerified) {
          // 2. Update Wallet Balance in Database
          await WalletService.addMoney(userId, amount);
          
          // 3. Trigger Real-time Voice Alert (High-End Feature)
          await PaymentAlertService().announcePayment(
            amount: amount,
            languageCode: "bn-BD",
          );
          
          if (!mounted) return;
          _showStatusSnackBar("Payment Verified & Wallet Updated! ✅", Colors.green);
        } else {
          if (!mounted) return;
          _showStatusSnackBar("Verification Failed! Contact Support.", Colors.red);
        }
      },
      error: (response) {
        _showStatusSnackBar("Payment Failed or Cancelled!", Colors.orange);
      },
      external: (response) {
        debugPrint("External Wallet Transaction Detected");
      },
    );
  }

  void _showStatusSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
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
      backgroundColor: Colors.black, // Reelzo Signature Theme
      appBar: AppBar(
        title: const Text("Reelzo Wallet", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // --- 💳 BALANCE CARD SECTION ---
              _buildBalanceCard(),

              const SizedBox(height: 50),

              // --- ⚡ ACTION BUTTONS ---
              _buildActionButton(
                title: "Add ₹100 via Razorpay",
                icon: Icons.add_circle_outline,
                color: Colors.purpleAccent,
                onTap: () => _payment.openPayment(100),
              ),

              const SizedBox(height: 20),

              _buildActionButton(
                title: "Send ₹50 to user2",
                icon: Icons.send_rounded,
                color: Colors.white12,
                onTap: () => WalletService.sendMoney(from: userId, to: "user2", amount: 50),
              ),
              
              const SizedBox(height: 30),
              const Text(
                "Secure Transactions by Reelzo SuperAdmin",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📊 Real-time Balance Display Widget
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: WalletService.getBalance(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var data = snapshot.data!.data() as Map<String, dynamic>?;
          double balance = (data != null && data.containsKey('balance')) 
              ? data['balance'].toDouble() 
              : 0.0;

          return Column(
            children: [
              const Text("TOTAL BALANCE", style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 10),
              Text(
                "₹$balance",
                style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔘 Universal Custom Button Builder
  Widget _buildActionButton({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}