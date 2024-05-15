import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisputeVerdict extends StatefulWidget {
  @override
  _DisputeVerdictState createState() => _DisputeVerdictState();
}

class _DisputeVerdictState extends State<DisputeVerdict> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> reviewedDisputes = {}; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispute Verdict'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('disputes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              if (reviewedDisputes.contains(document.id)) {
                return Container(); 
              }
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              String? subject = data['subject'];
              String? description = data['description'];
              if (subject == null || description == null) {
                return Container();
              }
              return ListTile(
                title: Text('Name: ${data['name']}, Date: ${data['date'].toDate()}'),
                subtitle: Text('Location: ${data['location']}, Description: ${data['description']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _updateVerdict(document.id, true, 'Warning'); 
                        setState(() {
                          reviewedDisputes.add(document.id); 
                        });
                      },
                      child: Text('Warning'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _updateVerdict(document.id, true, 'Approved'); 
                        setState(() {
                          reviewedDisputes.add(document.id); 
                        });
                      },
                      child: Text('Approved'),
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

  Future<void> _updateVerdict(String id, bool reviewed, String verdict) {
    return _firestore
        .collection('disputes')
        .doc(id)
        .update({'mgr_reviewed': reviewed, 'mgr_verdict': verdict})
        .then((value) => print("Verdict Updated"))
        .catchError((error) => print("Failed to update verdict: $error"));
  }
}
