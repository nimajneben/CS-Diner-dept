// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manju_restaurant/pages/home.dart';
import 'package:manju_restaurant/pages/surfer_home.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('MANJU', style: TextStyle(color: Colors.white)),
        
        centerTitle: true,
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(
            'Thank you for your submission!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'We will get back to you soon!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SurferHome()));
            },
            child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                                      width: 200,
                                      decoration:  BoxDecoration(color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(30)),
                                      
                                          
                                      child: Center(
                                        child: Text("MENU",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
          )
            
          ],
        ),
 
        
      ),
    );
  }
}