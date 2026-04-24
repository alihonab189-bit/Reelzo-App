import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  static final _db = FirebaseFirestore.instance;

  /// 🆕 Initialize a new wallet for a user
  static Future<void> createWallet(String userId) async {
    await _db.collection("wallets").doc(userId).set({
      "balance": 0.0,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// 💰 Add money to wallet and record transaction history
  static Future<void> addMoney(String userId, double amount) async {
    var walletRef = _db.collection("wallets").doc(userId);

    await _db.runTransaction((transaction) async {
      var snapshot = await transaction.get(walletRef);
      
      double currentBalance = (snapshot.data() as Map<String, dynamic>?)?["balance"] ?? 0.0;
      
      // Update the user's wallet balance
      transaction.update(walletRef, {"balance": currentBalance + amount});

      // 🔥 Automatically Create Transaction History Record
      var historyRef = _db.collection("transactions").doc(); 
      transaction.set(historyRef, {
        "userId": userId,
        "amount": amount,
        "type": "deposit",
        "timestamp": FieldValue.serverTimestamp(),
        "status": "success",
        "description": "Added via Razorpay"
      });
    });
  }

  /// 💸 Peer-to-peer transfer with dual transaction logging
  static Future<void> sendMoney({
    required String from,
    required String to,
    required double amount,
  }) async {
    var fromRef = _db.collection("wallets").doc(from);
    var toRef = _db.collection("wallets").doc(to);

    await _db.runTransaction((transaction) async {
      var fromSnap = await transaction.get(fromRef);
      var toSnap = await transaction.get(toRef);

      double fromBalance = (fromSnap.data() as Map<String, dynamic>?)?["balance"] ?? 0.0;
      double toBalance = (toSnap.data() as Map<String, dynamic>?)?["balance"] ?? 0.0;

      if (fromBalance >= amount) {
        // Update both balances atomically
        transaction.update(fromRef, {"balance": fromBalance - amount});
        transaction.update(toRef, {"balance": toBalance + amount});

        // 🔥 Log Transaction for Sender
        transaction.set(_db.collection("transactions").doc(), {
          "userId": from,
          "amount": amount,
          "type": "transfer_sent",
          "recipientId": to,
          "timestamp": FieldValue.serverTimestamp(),
        });

        // 🔥 Log Transaction for Receiver
        transaction.set(_db.collection("transactions").doc(), {
          "userId": to,
          "amount": amount,
          "type": "transfer_received",
          "senderId": from,
          "timestamp": FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// 📊 Stream real-time wallet balance
  static Stream<DocumentSnapshot> getBalance(String userId) {
    return _db.collection("wallets").doc(userId).snapshots();
  }

  /// 📜 Fetch Transaction History (Descending order by timestamp)
  static Stream<QuerySnapshot> getTransactionHistory(String userId) {
    return _db.collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}