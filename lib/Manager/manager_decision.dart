import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerDecision extends StatefulWidget {
  @override
  _ManagerDecisionState createState() => _ManagerDecisionState();
}

class _ManagerDecisionState extends State<ManagerDecision> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> reviewedComplaints = {}; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Decision'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('complaints')
            .where('status', isEqualTo: 'Customer')
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
              if (reviewedComplaints.contains(document.id)) {
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
                subtitle: Text('Location: ${data['location']}, Address: ${data['address']}, Address2: ${data['status']}, Description: ${data['description']}, Accuse Name: ${data['accuseName']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _updateVerdict(document.id, true, 'guilty'); 
                        setState(() {
                          reviewedComplaints.add(document.id); 
                        });
                      },
                      child: Text('Guilty'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _updateVerdict(document.id, true, 'not guilty'); 
                        setState(() {
                          reviewedComplaints.add(document.id); 
                        });
                      },
                      child: Text('Not Guilty'),
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
        .collection('complaints')
        .doc(id)
        .update({'mgr_reviewed': reviewed, 'mgr_verdict': verdict})
        .then((value) => print("Verdict Updated"))
        .catchError((error) => print("Failed to update verdict: $error"));
  }
}
