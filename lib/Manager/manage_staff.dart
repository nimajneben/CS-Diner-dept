import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manju_three/pages/login.dart';
import 'package:manju_three/Manager/view_to_fire.dart';

/* IDEA : 

<<    Manage Staff   [LOGOUT]
______________________________

 CHEF
   [John Doe]
   ID: 12345
   Compliments: 10
   Complaints: 2
   Warnings: 1
   [VIEW] [FIRE]

 IMPORTER
   [Jane Smith]
   ID: 67890
   Compliments: 5
   Complaints: 1
   Warnings: 0
   [VIEW] [FIRE]

 DELIVERER
   [Bob Marley]
   ID: 11223
   Compliments: 8
   Complaints: 0
   Warnings: 0
   [VIEW] [FIRE]

*/

class ManageStaff extends StatelessWidget {
  // make sure it's 'admin' logged in & accessing the page
  Future<bool> _isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = userDoc.data()?['role'];
      return role == 'admin';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        // make sure user logged in is admin: _isAdmin function to check the user's role
        future: _isAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (!snapshot.hasData || !snapshot.data!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
            });
            return Container();
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('Manage Staff',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.purple,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isNotEqualTo: 'admin')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No staff data available'));
                }

                List<DocumentSnapshot> staffDocs = snapshot.data!.docs;
                Map<String, List<DocumentSnapshot>> staffByRole = {
                  'chef': [],
                  'importer': [],
                  'delivery': [],
                };

                for (var doc in staffDocs) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  staffByRole[data['role']]?.add(doc);
                }

                return ListView(
                  children: staffByRole.entries.map((entry) {
                    return ExpansionTile(
                      title: Text(entry.key.toUpperCase()),
                      children: entry.value.map((doc) {
                        return ListTile(
                          title: Text(doc['name']),
                          subtitle:
                              Text('ID: ${doc.id}\nEmail: ${doc['email']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StaffProfilePage(staffId: doc.id)),
                                  );
                                },
                                child: Text('VIEW'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Confirm your action:'),
                                      content: Text(
                                          'Are you sure you want to fire this employee?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(doc.id)
                                                .delete();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Yes, Fire'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text('FIRE'),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            ),
          );
        });
  }
}
