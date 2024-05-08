// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter/widgets.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Wallet', style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Container(
          
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white), 
            child: 
            Row(children: [
              Image.asset("images/wallet_02.jpg", width: 70, height: 70,),
              SizedBox(width: 20,),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Your Wallet", style: AppWidget.semiBoldTextFieldStyle(),),
                Text("\$" + "1000", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
            ],),
            
  
         ),
         Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Add Money:", style: AppWidget.semiBoldTextFieldStyle(),)),
          SizedBox(height: 10,),
        
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text("\$" + "10", style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 20),),
              ),
               Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text("\$" + "20", style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 20),),
              ),
               Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text("\$" + "50", style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 20),),
              ),
               Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text("\$" + "100", style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 20),),
              )
            ],
          ),
          SizedBox(height: 50,),
          Container(margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 12),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF008080)
          ),
          child: Center(
            child: Text("Add Money", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ),
          
      ]),
    );
  }
}
