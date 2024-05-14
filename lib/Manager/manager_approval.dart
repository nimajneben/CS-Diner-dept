import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManagerApproval extends StatefulWidget {
  @override
  _ManagerApprovalState createState() => _ManagerApprovalState();
}

class _ManagerApprovalState extends State<ManagerApproval> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Approval'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users')
            .where('role', isEqualTo: 'customer')
            .where('isApproved', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text('Name: ${data['name']}, Email: ${data['email']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('Approve'),
                      onPressed: () {
                        document.reference.update({'isApproved': true});
                      },
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      child: Text('Not Approve'),
                      onPressed: () {
                        document.reference.delete();
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

