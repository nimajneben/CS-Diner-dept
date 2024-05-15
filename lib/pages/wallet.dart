// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter/widgets.dart';
import 'package:manju_three/widget/widget_support.dart';
import 'package:manju_three/methods/wallet_state.dart';
import 'package:provider/provider.dart';

final String uid = FirebaseAuth.instance.currentUser!.uid;

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
        title: Text('Wallet',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Image.asset(
                "assets/images/wallet_02.jpg",
                cacheHeight: 70,
                cacheWidth: 70,
              ),
              SizedBox(
                width: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Your Wallet",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                WalletBalanceView(),
              ]),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Add Money:",
              style: AppWidget.semiBoldTextFieldStyle(),
            )),
        SizedBox(
          height: 10,
        ),
        WalletManagementButtons(),
        SizedBox(
          height: 50,
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 20),
        //   padding: EdgeInsets.symmetric(vertical: 12),
        //   width: MediaQuery.of(context).size.width,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: Color(0xFF008080)),
        //   child: Center(
        //     child: Text(
        //       "Add Money",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}

class WalletManagementButtons extends StatelessWidget {
  const WalletManagementButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => {wallet.addBalance(10.00)},
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Color(0xFF008080),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              "\$" + "10",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {wallet.addBalance(20.00)},
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Color(0xFF008080),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              "\$" + "20",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {wallet.addBalance(50.00)},
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Color(0xFF008080),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              "\$" + "50",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {wallet.addBalance(100.00)},
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Color(0xFF008080),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              "\$" + "100",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        )
      ],
    );
  }
}

class WalletBalanceView extends StatefulWidget {
  const WalletBalanceView({super.key});
  @override
  State<StatefulWidget> createState() => _WalletBalanceView();
}

SyncWalletModel wallet = SyncWalletModel(uid);

class _WalletBalanceView extends State<WalletBalanceView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    double balance = wallet.balance / 100.0;
    // TODO: Format Currency Properly
    return Text('\$$balance');
  }

  // @override
  // Widget build(BuildContext context) {
  //   double balance = wallet.balance / 100.0;
  //   return Consumer<WalletModel>(
  //       builder: ((context, _, child) => Text('\$$balance')));
  // }
}
