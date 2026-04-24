import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../services/wallet_service.dart';
import '../services/payment_service.dart';
import '../services/super_admin_service.dart';
import '../services/payment_alert_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _payment = PaymentService();
  late ConfettiController _confettiController;
  
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";
  double selectedAmount = 100.0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initializePaymentGateway();
  }

  void _initializePaymentGateway() {
    _payment.init(
      success: (response) async {
        debugPrint("Gateway Success. Verifying...");

        bool isVerified = await SuperAdminService.verifyPayment(selectedAmount);
        
        if (isVerified) {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 100, amplitude: 128);
          }

          await WalletService.addMoney(userId, selectedAmount);
          _confettiController.play();

          await PaymentAlertService().announcePayment(
            amount: selectedAmount,
            languageCode: "bn-BD",
          );
          
          _showAdvancedSnackBar("Payment Successful! Enjoy Reelzo Plus ✅", Colors.green);
        } else {
          _showAdvancedSnackBar("Security Verification Failed! ❌", Colors.red);
        }
      },
      error: (response) {
        _showAdvancedSnackBar("Transaction Cancelled ⚠️", Colors.orange);
      },
      // 🔥 FIX: Added the missing 'external' parameter here
      external: (response) {
        debugPrint("External Wallet Transaction Detected");
      },
    );
  }

  void _showAdvancedSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _payment.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Reelzo Wallet", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildBalanceCard(),
                  const SizedBox(height: 40),
                  _buildAmountSelector(),
                  const SizedBox(height: 30),
                  _buildActionButton(
                    title: "Deposit ₹$selectedAmount",
                    icon: Icons.bolt,
                    color: Colors.purpleAccent,
                    onTap: () => _payment.openPayment(selectedAmount),
                  ),
                  const SizedBox(height: 15),
                  _buildActionButton(
                    title: "Transaction History",
                    icon: Icons.history,
                    color: Colors.white10,
                    onTap: () {
                      // Navigate to history screen
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple.shade900, Colors.black]),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: WalletService.getBalance(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          double balance = (data?['balance'] ?? 0.0).toDouble();

          return Column(
            children: [
              const Text("AVAILABLE BALANCE", style: TextStyle(color: Colors.white54, letterSpacing: 1.5, fontSize: 11)),
              const SizedBox(height: 8),
              Text("₹$balance", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAmountSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [100, 500, 1000].map((amt) {
        bool isSelected = selectedAmount == amt.toDouble();
        return GestureDetector(
          onTap: () {
            Vibration.vibrate(duration: 10);
            setState(() => selectedAmount = amt.toDouble());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
              color: isSelected ? Colors.purpleAccent : Colors.white12,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
            ),
            child: Text("₹$amt", style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}