

import "package:flutter/material.dart";
import "package:manju_restaurant/pages/profile.dart";
import "package:manju_restaurant/pages/wallet.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";


import "customer_order.dart";
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
  late CustomerOrder customerOrder;
  late Profile profile;

  @override
  void initState() {
    // TODO: implement initState
    homepage =  Home();
    wallet =  Wallet();
    customerOrder =  CustomerOrder();
    profile =  Profile();

    pages = [homepage, customerOrder, wallet, profile];
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
        onTap: (int index){
          setState(() {
            currentTabIndex = index;});
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white,),
          Icon(Icons.shopping_bag_outlined, color: Colors.white,),
          Icon(Icons.wallet_outlined, color: Colors.white,),
          Icon(Icons.person_outline, color: Colors.white,),
        ],
      ),

      body: pages[currentTabIndex],
    );
  }
}
