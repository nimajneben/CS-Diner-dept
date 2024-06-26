// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manju_three/pages/surfer_home.dart';
import 'package:manju_three/widget/widget_support.dart';

class ChefProfile extends StatefulWidget {
  const ChefProfile({super.key});

  @override
  State<ChefProfile> createState() => _ChefProfileState();
}

class _ChefProfileState extends State<ChefProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.redAccent,
        title: Text("Profile", style: AppWidget.boldTextFieldStyle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_sharp, color: Colors.black, size: 30),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SurferHome()),
                  (route) => false);
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 150,
                backgroundImage: AssetImage("images/profile1.jpg"),
              ),
            ),
            SizedBox(height: 50),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Name: John Doe",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email: chefjohn@manju.com",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
