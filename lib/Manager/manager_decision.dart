import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerDecision extends StatefulWidget {
  @override
  _ManagerDecisionState createState() => _ManagerDecisionState();
}

class _ManagerDecisionState extends State<ManagerDecision> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Decision'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('complaints').snapshots(),
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
                title: Text(data['subject']),
                subtitle: Text(data['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _updateVerdict(document.id, true),
                      child: Text('Guilty'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateVerdict(document.id, false),
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

  Future<void> _updateVerdict(String id, bool verdict) {
    return _firestore
        .collection('complaints')
        .doc(id)
        .update({'mgr_verdict': verdict})
        .then((value) => print("Verdict Updated"))
        .catchError((error) => print("Failed to update verdict: $error"));
  }
}
