import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManagerStaff extends StatefulWidget {
  @override
  _ManagerStaffState createState() => _ManagerStaffState();
}

class _ManagerStaffState extends State<ManagerStaff> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Staff'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('staff')
            .where('status', whereIn: ['Importer', 'Delivery', 'Chef'])
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
                title: Text('Name: ${data['name']}, Description: ${data['description']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('Innocent'),
                      onPressed: () {
                        document.reference.update({
                          'mgr_reviewed': true,
                          'mgr_verdict': 'innocent'
                        });
                      },
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      child: Text('Guilty'),
                      onPressed: () {
                        document.reference.update({
                          'mgr_reviewed': true,
                          'mgr_verdict': 'guilty'
                        });
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
