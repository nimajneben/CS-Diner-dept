import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:manju_three/methods/data.dart';

class Wallet {
  late double balance;
  Wallet([double? amount]) {
    balance = amount ?? 0.0;
  }
}

class WalletModel extends ChangeNotifier {
  final _wallet = Wallet();

  // Get wallet balance
  double get balance => _wallet.balance;

  // Add balance to the wallet
  void addBalance(int amount) {
    _wallet.balance += amount;
    notifyListeners();
  }
}

String uid = FirebaseAuth.instance.currentUser!.uid;
Future<int> getWalletAmount() async {
  var snapshot = await DatabaseFunctions().getUserWallet(uid);
  return snapshot;
}

// Wallet that's synchronized with Firestore
class SyncWallet {
  double balance = 0.0;
  final database = FirebaseFirestore.instance;
  var documentReference;

  // Obtain balance from Firestore.
  // If not available, then just initialize a blank wallet.
  SyncWallet(String uid) {
    documentReference = database.collection("users").doc(uid);
    documentReference.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("wallet")) {
          balance = double.parse(data["wallet"].toString());
        } else {
          // Initalize balance if user doesn't have a wallet
          balance = 0;
        }
      } else {
        debugPrint("user does not exist");
      }
    });
  }

  // Publish new balance to Firestore
  void updateAmount() {
    documentReference = database.collection("users").doc(uid);
    documentReference.update({'wallet': balance});
  }
}

class SyncWalletModel with ChangeNotifier {
  late final SyncWallet _wallet;
  SyncWalletModel(uid) {
    _wallet = SyncWallet(uid);
    notifyListeners();
  }

  double get balance => _wallet.balance;

  // Add balance to the wallet
  void addBalance(double amount) {
    _wallet.balance += amount;
    _wallet.updateAmount();
    notifyListeners();
  }
}
