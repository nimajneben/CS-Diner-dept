import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseFunctions{


  /**
   * Function used to add menu item to the database,
   * need to pass a map of the item data and the function will add it to the database
   * the pictures are stored in the firebase storage and the url is stored in the database
   */
  Future addMemuItem(Map<String, dynamic> itemData) async {
    return await FirebaseFirestore.instance.collection("Menu").doc()
      .set(itemData);
    }

/**
 * 
 * this function is a stre
 */
  Future <Stream<QuerySnapshot>> getMenuItems(String category) async{
    return await FirebaseFirestore.instance
    .collection("Menu")
    .where("category", isEqualTo: category)
    .snapshots();
  }

/**
 * 
 * this fucntion returns the role of the user
 * 
 * 
 */

Future<String> getUserRole(String uid) async {
  return await FirebaseFirestore.instance.collection("users")
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


Future<void> logout() async{
  try{
    await FirebaseAuth.instance.signOut();
  } catch(e){
    print(e.toString());
  }
}

/**
 * 
 * 
 * 
 */

Future<String> getChefName(String uid) async {
  return await FirebaseFirestore.instance.collection("users")
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




  Future<dynamic> getUserInfo(String uid) async {
  return await FirebaseFirestore.instance.collection("users")
    .doc(uid)
    .get()
    .then((value) {
      var data = value.data();
      if (data != null) {
        return data;
      } else {
        // Handle the case where data is null
        throw Exception('User data is null');
      }
    });
}

}
Future<String> fetchUserName() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return userData['name']; // Assuming 'name' is the field that stores user names.
  }
  return 'No Name'; // Default or error value
}