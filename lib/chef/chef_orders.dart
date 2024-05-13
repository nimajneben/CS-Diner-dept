import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// logout button, redirect to login.dart
import 'package:manju_restaurant/pages/login.dart';


// SERVE ORDERS -- (currently) IRRESPECTIVE of WHICH CHEF is named
//       >> Display All Orders (Menu Item Names)
//       >> 'SERVED' Button
//       >> Firestore 'Orders' database : 
//                >> 'isOrderComplete' == true

// NOTE 0 : in 'Menu', currently queries for 'Name' field or 'itemName' field
//          in 'Orders', assumes 'order' array exists; collection of 'Menu' item references

// NOTE 1 : Can't Update the Ingredients Inventory AUTOMATICALLY
//              if 'Menu' items aren't created with an 'Ingredients' array,
//          SO---- Chefs MUST Update the Ingredients Inventory MANUALLY (<< currently method )
//          OR---- Could make a 'Menu-Ingre' database; each document is a Menu item;
//                  has an array of Ingredients; & use Ingredients array to update Inventory
//              BUT !! INGREDIENTS database needs to be populated upon 'Menu' item creation 
//

/* IDEA : 

<<   Pending Orders   [LOGOUT]
____________________________________

Order ID: (ABC123)
Menu Item: (Item 1)
Menu Item: (Item 2)
Menu Item: (Item 3)
[SERVED]

Order ID: (DEF000)
Menu Item: (Item 4)
Menu Item: (Item 5)
[SERVED]

Order ID: (XYZ999)
Menu Item: (Item 6)
Menu Item: (Item 7)
Menu Item: (Item 8)
Menu Item: (Item 9)
[SERVED]

... [ cont'd list of orders    ]
... [ from 'Orders' collection ]

*/



class Order {
  final String id;
  final bool isOrderComplete;
  final List<DocumentReference> order;

  Order({required this.id, required this.isOrderComplete, required this.order});
}

class MenuItem {
  final String name;
  MenuItem({required this.name});
}

class OrdersPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final chefID = user?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Pending Orders", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_sharp, color: Colors.black, size: 30),
            onPressed: () => _logout(context),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').where('isOrderComplete', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orderRef = snapshot.data!.docs.map((doc) {
            final order = List<DocumentReference>.from(doc['order']);
            return Order(id: doc.id, isOrderComplete: doc['isOrderComplete'], order: order);
          }).toList();

          return ListView.builder(
            itemCount: orderRef.length,
            itemBuilder: (context, index) {
              final order = orderRef[index];
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: FutureBuilder<List<MenuItem>>(
                  future: _getMenuItems(order.order, chefID!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final menuItems = snapshot.data ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final menuItem in menuItems) Text('Menu Item: ${menuItem.name}'), // .name ?
                      ],
                    );
                  },
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Orders').doc(order.id).update({
                      'isOrderComplete': true,
                    })
                    .then((_) => print('Order is served: ${order.id}'))
                    .catchError((error) => print('Error updating order: $error'));
                  },
                  child: Text('SERVED'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<MenuItem>> _getMenuItems(List<DocumentReference> orderReferences, String chefID) async {
    final menuItems = <MenuItem>[];
    for (final reference in orderReferences) {
      try {
        final snapshot = await reference.get();
        if (snapshot.exists && snapshot['chefID'] == chefID) {
          final menuItemName = snapshot['Name'] ?? snapshot['itemName'];    // checks for 'Name' or 'itemName'
          menuItems.add(MenuItem(name: menuItemName));
        }
      } catch (e) {
        print('Error fetching menu item: $e');
      }
    }
    return menuItems;
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    } catch (e) {
      _showErrorDialog(context, 'Failed to log out: ${e.toString()}');
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Dismiss', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
}