// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:manju_three/chef/add_menu.dart';
import 'package:manju_three/chef/chef_home.dart';
import 'package:manju_three/chef/chef_profile.dart';
import 'package:manju_three/chef/edit_menu.dart';
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
  //
  late AddMenuItem addMenu;
  late EditMenu editMenu;
  late EditMenuItemPage editItem;
  late OrdersPage chefOrders;
  late ChefIngredientsPage chefIngredients;

  late ChefProfile chefProfile;

  @override
  void initState() {
    // TODO: implement initState
    chefHome = ChefHome();
    // editMenu =  EditMenu();
    addMenu = AddMenuItem();
    chefProfile = ChefProfile();
    chefHome = ChefHome();
    editMenu = EditMenu();
    addMenu = AddMenuItem();
    chefProfile = ChefProfile();
    chefOrders = OrdersPage();
    chefIngredients = ChefIngredientsPage();

    pages = [
      chefHome,
      addMenu,
      editMenu,
      chefOrders,
      chefIngredients,
      chefProfile
    ];
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
            Icons.add_circle_outline,
            color: Colors.white,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Icon(
            Icons.format_list_bulleted,
            color: Colors.white,
          ),
          Icon(
            Icons.kitchen,
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
