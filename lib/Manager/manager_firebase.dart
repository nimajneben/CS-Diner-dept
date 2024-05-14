import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirebaseManager {
  Future<void> addComplaint({
    required String name,
    required DateTime date,
    required String location,
    required String address,
    required String status,
    required String description,
    required String accuseName,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("not logged in");

    String collectionName = 'complaints';

    Map<String, dynamic> data = {
      'filersId': user.uid,
      'timestamp': Timestamp.now(),
      'name': name,
      'date': date,
      'location': location,
      'address': address,
      'status': status,
      'description': description,
      'accuseName': accuseName,
      'appealed_verdict': "unknown",
      'category': "what type of complaint",
      'mgr_reviewed': false,
      'mgr_verdict': "innocent",
      'subject': "what the user is complaining about-- could be an order id, menu id, procurement id, etc."
    };

    await FirebaseFirestore.instance.collection(collectionName).add(data);
  }
}
