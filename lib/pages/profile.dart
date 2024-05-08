// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

    User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.email);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Center(child: 
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 150,
              

              backgroundImage: AssetImage("images/profile1.jpg"),
            ),
          ),
          SizedBox(height: 50,),
          Container(
            
           child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Text("Name: ${user?.email ?? 'John Doe'}", style: AppWidget.boldTextFieldStyle(),),
              SizedBox(height: 10,),
              Text("Email: ${user?.email ?? 'john@johm.com'}", style: AppWidget.semiBoldTextFieldStyle(),),
            ],),
          )
      ],),),
    );
  }
}
