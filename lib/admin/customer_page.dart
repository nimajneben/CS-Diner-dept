// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:manju_restaurant/admin/suspended_user.dart';
import 'package:manju_restaurant/admin/unapproved_users.dart';
import 'package:manju_restaurant/chef/add_menu.dart';
import 'package:manju_restaurant/methods/data.dart';
import 'package:manju_restaurant/pages/login.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        backgroundColor: Colors.deepPurple,
        title: Text("Customers",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                DatabaseFunctions().logout();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LogIn()));
              },
              child: Icon(
                Icons.logout_sharp,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UnapprovedUsersPage()));
            },
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Unapproved Users",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SuspendedUser()));
            },
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.cancel_presentation_outlined,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Suspended Users",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
