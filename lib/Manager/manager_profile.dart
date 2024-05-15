import 'package:flutter/material.dart';
import 'package:manju_three/widget/widget_support.dart';
import 'package:manju_three/pages/user_registration.dart';

class ManagerProfile extends StatefulWidget {
  const ManagerProfile({super.key});

  @override
  State<ManagerProfile> createState() => _ManagerProfileState();
}

class _ManagerProfileState extends State<ManagerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple.shade100,
          title: Text("Profile", style: AppWidget.boldTextFieldStyle()),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout_sharp, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
            ),
            SizedBox(width: 20),
          ]),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 150,
                backgroundImage: AssetImage("assets/images/profile1.jpg"),
              ),
            ),
            SizedBox(height: 50),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Name: Jane Doe",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email: managerjane@manju.com",
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
