import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manju_three/widget/widget_support.dart';
import 'package:manju_three/pages/login.dart';

/* IDEA : 

<<    (Staff Name)   [LOGOUT]
______________________________
|
|    (Staff Name)
|
|
|    (all database info)
|
|    [FIRE]
|
|

*/


class StaffProfilePage extends StatefulWidget {
    final String staffId;
    const StaffProfilePage({super.key, required this.staffId});

    @override
    State<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
    // make sure 'admin' is logged in
    Future<bool> _isAdmin() async {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
            return userDoc.exists && userDoc['role'] == 'admin';
        }
        return false;
    }

    @override
    Widget build(BuildContext context) {

        return FutureBuilder<bool>(
            future: _isAdmin(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (!snapshot.hasData || !snapshot.data!) {
                    Future.microtask(() =>
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                    )
                    );
                    return Container();
                }

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.purple.shade100,
            title: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(widget.staffId).get(),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading...", style: AppWidget.boldTextFieldStyle());
                    }
                    if (!snapshot.hasData) {
                        return Text("No Data", style: AppWidget.boldTextFieldStyle());
                    }
                    String staffName = snapshot.data!['name'];
                    return Text(staffName, style: AppWidget.boldTextFieldStyle());
                },
            ),
            centerTitle: true,
            actions: [
                IconButton(
                    icon: Icon(Icons.logout_sharp, color: Colors.black, size: 30),
                    onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                    );
                    },
                ),
                SizedBox(width: 20),
            ],
        ),

        body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(widget.staffId).get(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                    return Center(child: Text('No staff data available'));
                }
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Column(
                            children: data.entries.map((entry) {
                                return Text('**${entry.key}** : ${entry.value}');
                            }).toList(),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                                onPressed: () {
                                    showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        title: Text('Confirm your action:'),
                                        content: Text('Are you sure you want to fire this employee?'),
                                        actions: [
                                            TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: Text('Cancel'),
                                            ),
                                            TextButton(
                                                style: TextButton.styleFrom(primary: Colors.redAccent),
                                                onPressed: () {
                                                FirebaseFirestore.instance.collection('users').doc(widget.staffId).delete();
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
                        ),
                    ],
                    ),
                );
            },
        ),
    );
  }
}
