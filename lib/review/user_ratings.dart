import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class UserRatings extends StatefulWidget {
  const UserRatings({super.key});

  @override
  State<UserRatings> createState() => _UserRatingsState();
}

class _UserRatingsState extends State<UserRatings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Ratings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20,),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.star, color: Colors.yellow[900], size: 80),
                    Text("4.5", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text("Wie's Hot Mess", style: AppWidget.headLineTextFieldStyle()),
                    Text("Chef Wie", style: AppWidget.semiBoldTextFieldStyle()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
