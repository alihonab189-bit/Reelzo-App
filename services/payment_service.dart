import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;

  void init({
    required Function success,
    required Function error,
    required Function external,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, success);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, error);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, external);
  }

  void openPayment(double amount) {
    var options = {
      'key': 'rzp_test_SayuDBzOdqW5Kf', 
      'amount': (amount * 100).toInt(), 
      'name': 'Reelzo',
      'description': 'Reelzo Wallet Top-up',
      'prefill': {
        'contact': '01XXXXXXXXX', 
        'email': 'ali@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
    }
  }

  void dispose() {
    _razorpay.clear(); 
  }
}