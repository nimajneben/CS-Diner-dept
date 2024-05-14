import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:manju_three/methods/data.dart";
import "package:manju_three/pages/profile_screen.dart";
import "package:manju_three/pages/wallet.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";

import "cart_details.dart";
import "home.dart";

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Wallet wallet;
  late CartDetails cartDetails;
  late Profile profile;

  @override
  void initState() {
    // TODO: implement initState

    homepage = Home();
    wallet = Wallet();
    cartDetails = CartDetails();
    profile = Profile();

    pages = [homepage, cartDetails, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 200),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.wallet_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
