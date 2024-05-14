import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManagerGuilty extends StatefulWidget {
  @override
  _ManagerGuiltyState createState() => _ManagerGuiltyState();
}

class _ManagerGuiltyState extends State<ManagerGuilty> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('complaints')
            .where('mgr_verdict', isEqualTo: 'guilty')
            .where('status', isEqualTo: 'Customer') // Add this line
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
