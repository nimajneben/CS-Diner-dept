import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:manju_three/methods/data.dart';

class Wallet {
  late int balance;
  Wallet([int? amount]) {
    balance = amount ?? 0;
  }
}

class WalletModel extends ChangeNotifier {
  final _wallet = Wallet();

  // Get wallet balance
  int get balance => _wallet.balance;

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
  int balance = 0;
  final database = FirebaseFirestore.instance;
  late final dynamic documentReference;

  // Obtain balance from Firestore.
  // If not available, then just initialize a blank wallet.
  SyncWallet(String uid) {
    documentReference = database.collection("users").doc(uid);
    documentReference.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("wallet")) {
          balance = int.parse(data["wallet"].toString());
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
    documentReference.update({'wallet': balance}).then(
        (value) => debugPrint("Balance Updated Successfully"),
        onerror: (e) => debugPrint("Balance failed to update: $e"));
  }
}

class SyncWalletModel extends ChangeNotifier {
  late final SyncWallet _wallet;
  SyncWalletModel(uid) {
    _wallet = SyncWallet(uid);
  }

  int get balance => _wallet.balance;

  // Add balance to the wallet
  void addBalance(int amount) {
    _wallet.balance += amount;
    _wallet.updateAmount();
  }
}
