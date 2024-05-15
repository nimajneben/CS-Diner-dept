import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manju_three/chef/add_menu.dart';
import 'package:manju_three/methods/data.dart';
import 'package:manju_three/pages/login.dart';
import 'package:manju_three/widget/widget_support.dart';

class ChefHome extends StatefulWidget {
  const ChefHome({super.key});

  @override
  State<ChefHome> createState() => _ChefHomeState();
}

class _ChefHomeState extends State<ChefHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.menu),
          backgroundColor: Colors.redAccent,
          title: Text(
            "Chef Home",
            style: AppWidget.boldTextFieldStyle(),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  DatabaseFunctions().logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
                child: Icon(Icons.logout_sharp, color: Colors.black, size: 30)),
            SizedBox(width: 20),
          ]),
      body: Column(children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddMenuItem()));
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/images/dessert.jpg",
                      cacheHeight: 100,
                      cacheWidth: 100,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Add Menu Item",
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
      ]),
    );
  }
}
