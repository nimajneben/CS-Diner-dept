// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:manju_restaurant/chef/add_menu.dart';
import 'package:manju_restaurant/chef/chef_home.dart';
import 'package:manju_restaurant/chef/chef_profile.dart';
import 'package:manju_restaurant/chef/edit_menu.dart';
import "package:curved_navigation_bar/curved_navigation_bar.dart";

class ChefNav extends StatefulWidget {
  const ChefNav({super.key});

  @override
  State<ChefNav> createState() => _ChefNavState();
}

class _ChefNavState extends State<ChefNav> {

  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late ChefHome chefHome;
  // late EditMenu editMenu;
  late AddMenuItem addMenu;
  late ChefProfile chefProfile;

  @override
  void initState() {
    // TODO: implement initState
    chefHome =  ChefHome();
    // editMenu =  EditMenu();
    addMenu =  AddMenuItem();
    chefProfile =  ChefProfile();

    pages = [chefHome, addMenu, chefProfile];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.redAccent,
        animationDuration: Duration(milliseconds: 200),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;});
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white,),
          Icon(Icons.add_circle_outline, color: Colors.white,),
          Icon(Icons.person_outline, color: Colors.white,),
        ],
      ),

      body: pages[currentTabIndex],
    );
  }
}
