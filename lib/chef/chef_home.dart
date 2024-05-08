import 'package:flutter/material.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

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
        title: Text("Chef Home", style: AppWidget.boldTextFieldStyle(),),
        centerTitle: true,
        actions: [
          Icon(Icons.logout_sharp, color: Colors.black, size: 30),
          SizedBox(width: 20),]
      ),

      body: Row(children: [
        Container()

      ],)
    );
  }
}