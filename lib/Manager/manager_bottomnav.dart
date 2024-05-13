import 'package:flutter/material.dart';
import 'package:manju_three/Manager/manager_home.dart';
import 'package:manju_three/Manager/manager_profile.dart';
import "package:curved_navigation_bar/curved_navigation_bar.dart";

class ManagerNav extends StatefulWidget {
  const ManagerNav({super.key});

  @override
  State<ManagerNav> createState() => _ManagerNavState();
}

class _ManagerNavState extends State<ManagerNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    pages = [
      ManagerHome(), // Set ManagerHome as the first page
      ManagerProfile(), // Add ManagerProfile as the second page
      // Add other pages here when they are ready
    ];
    currentPage = pages[currentTabIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.purple,
        animationDuration: Duration(milliseconds: 200),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[currentTabIndex];
          });
        },
        items: [
          Icon(
            Icons.dashboard,
            color: Colors.white,
          ), // Icon for the ManagerHome page
          Icon(
            Icons.person,
            color: Colors.white,
          ), // Icon for the ManagerProfile page
          // Add more icons here when other pages are ready
        ],
      ),
      body: currentPage,
    );
  }
}
