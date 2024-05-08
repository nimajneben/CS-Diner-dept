// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

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
        backgroundColor: Colors.redAccent,
        title: Text("Profile", style: AppWidget.boldTextFieldStyle()),
        centerTitle: true,
        actions: [
          Icon(Icons.logout_sharp, color: Colors.black, size: 30),
          SizedBox(width: 20),]
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
                  Text("Email: chefjohn@manju.com", style: AppWidget.semiBoldTextFieldStyle(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}