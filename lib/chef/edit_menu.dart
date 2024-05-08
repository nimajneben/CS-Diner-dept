import 'package:flutter/material.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Edit Menu", style: AppWidget.boldTextFieldStyle(),),
        centerTitle: true,
        actions: [
          Icon(Icons.logout_sharp, color: Colors.black, size: 30),
          SizedBox(width: 20),]
      ),

      body: Column(children: [
        

      ],),
    );
  }
}