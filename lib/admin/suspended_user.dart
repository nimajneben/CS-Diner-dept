import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class SuspendedUser extends StatefulWidget {
  const SuspendedUser({super.key});

  @override
  State<SuspendedUser> createState() => _SuspendedUserState();
}

class _SuspendedUserState extends State<SuspendedUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suspended Users", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isSuspended', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users to Reinstate", style: AppWidget.boldTextFieldStyle(),),);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  
                  title: Text(user['name'], style: AppWidget.boldTextFieldStyle(),), // Adjust according to your user data structure
                  subtitle: Text("Warnings: ${user['warning']}", 
                  style: AppWidget.semiBoldTextFieldStyle()),
                  tileColor: Colors.deepPurple[100],
                  trailing: ElevatedButton(
                    child: Text("ReInstate",),
                    
                    onPressed: () => _reinstateUser(user.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _reinstateUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isSuspended': false
    }).then((_) {
      print("User reinstated successfully!");
    }).catchError((error) {
      print("Failed to reinstate user: $error");
    });
  }
}
