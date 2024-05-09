import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class UnapprovedUsersPage extends StatefulWidget {
  @override
  _UnapprovedUsersPageState createState() => _UnapprovedUsersPageState();
}

class _UnapprovedUsersPageState extends State<UnapprovedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unapproved Users", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isApproved', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No unapproved users found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  
                  title: Text(user['name'], style: AppWidget.boldTextFieldStyle(),), // Adjust according to your user data structure
                  subtitle: Text("Deposit: ${user['deposit']}", 
                  style: AppWidget.semiBoldTextFieldStyle()),
                  tileColor: Colors.deepPurple[100],
                  trailing: ElevatedButton(
                    child: Text("Approve",),
                    
                    onPressed: () => _approveUser(user.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _approveUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isApproved': true
    }).then((_) {
      print("User approved successfully!");
    }).catchError((error) {
      print("Failed to approve user: $error");
    });
  }
}
