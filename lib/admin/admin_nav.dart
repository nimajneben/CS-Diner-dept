// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:manju_restaurant/admin/customer_page.dart';
import 'package:manju_restaurant/admin/unapproved_users.dart';
import 'package:manju_restaurant/chef/add_menu.dart';
import 'package:manju_restaurant/chef/chef_home.dart';
import 'package:manju_restaurant/chef/chef_profile.dart';
import 'package:manju_restaurant/chef/edit_menu.dart';
import "package:curved_navigation_bar/curved_navigation_bar.dart";

class AdminNav extends StatefulWidget {
  const AdminNav({super.key});

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {

  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late CustomerPage customerPage;
  // late EditMenu editMenu;
  late AddMenuItem addMenu;
  late ChefProfile chefProfile;

  @override
  void initState() {
    // TODO: implement initState
    customerPage =  CustomerPage();
    // editMenu =  EditMenu();
    addMenu =  AddMenuItem();
    chefProfile =  ChefProfile();

    pages = [customerPage, addMenu, chefProfile];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        animationDuration: Duration(milliseconds: 200),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;});
        },
        items: [
          Icon(Icons.dashboard, color: Colors.white,),
          Icon(Icons.add_circle_outline, color: Colors.white,),
          Icon(Icons.person_outline, color: Colors.white,),
        ],
      ),

      body: pages[currentTabIndex],
    );
  }
}
