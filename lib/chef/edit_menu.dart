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
        title: Text("Add Menu", style: AppWidget.boldTextFieldStyle(),),
        centerTitle: true,
        actions: [
          Icon(Icons.logout_sharp, color: Colors.black, size: 30),
          SizedBox(width: 20),]
      ),

      body: Container(
        
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Text("Please select a picture for the menu!", style: AppWidget.boldTextFieldStyle(),),
          ],

        ),

        
        ),



      
    );
  }
}