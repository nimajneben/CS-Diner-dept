import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseFunctions {
  /**
   * Function used to add menu item to the database,
   * need to pass a map of the item data and the function will add it to the database
   * the pictures are stored in the firebase storage and the url is stored in the database
   */
  Future addMemuItem(Map<String, dynamic> itemData) async {
    return await FirebaseFirestore.instance
        .collection("Menu")
        .doc()
        .set(itemData);
  }

/**
 * 
 * this function is a stre
 */
  Future<Stream<QuerySnapshot>> getMenuItems(String category) async {
    return await FirebaseFirestore.instance
        .collection("Menu")
        .where("category", isEqualTo: category)
        .snapshots();
  }
  /**
 * 
 * this fucntion returns top 3 rated dishes of each category
 * 
 * 
 */

  Future<Stream<QuerySnapshot>> getTopRatedItems(String category) async {
    return await FirebaseFirestore.instance
        .collection("Menu")
        .where('category', isEqualTo: category)
        .orderBy("rating", descending: true)
        .limit(3)
        .snapshots();
  }

/**
 * 
 * this fucntion returns the role of the user
 * 
 * 
 */

  Future<String> getUserRole(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      var data = value.data();
      if (data != null) {
        return data['role'];
      } else {
        // Handle the case where data is null
        throw Exception('User data is null');
      }
    });
  }

//**
// Universal logout button
//
// */

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

/**
 * 
 * Used to get the name of the chef
 * 
 */

  Future<String> getChefName(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      var data = value.data();
      if (data != null) {
        return data['name'];
      } else {
        // Handle the case where data is null
        throw Exception('User data is null');
      }
    });
  }

/**
 * 
 * 
 * Returns the approval status of the user
 * 
*/

  Future<dynamic> getApprovalInfo(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      var data = value.data();
      if (data != null) {
        return data['isApproved'];
      } else {
        // Handle the case where data is null
        throw Exception('User data is null');
      }
    });
  }

/**
 * 
 * 
 * 
 */

  Future<int> getUserWallet(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      var data = value.data();
      if (data != null) {
        return data['deposit'];
      } else {
        // Handle the case where data is null
        throw Exception('User data is null');
      }
    });
  }

  Future<void> addMoneyToUserWallet(String uid, double amountToAdd) async {
    var userRef = FirebaseFirestore.instance.collection("users").doc(uid);
    var transactionResponse =
        await FirebaseFirestore.instance.runTransaction((transaction) async {
      var userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) {
        throw Exception('User does not exist');
      }

      var userData = userSnapshot.data();
      if (userData != null && userData['deposit'] != null) {
        double currentWallet = userData['deposit'] as double;
        double updatedWallet = currentWallet + amountToAdd;
        transaction.update(userRef, {'wallet': updatedWallet});
      } else {
        throw Exception('Wallet data is missing or null');
      }
    }).catchError((error) {
      throw Exception('Failed to update wallet: $error');
    });

    return transactionResponse;
  }
}
