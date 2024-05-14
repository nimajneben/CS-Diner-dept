import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manju_three/pages/login.dart';
import 'package:manju_three/chef/chef_home.dart';

// SERVE ORDERS --
//       >> Display All Orders (Menu Item Names) -- shows items they're responsible for
//       >> 'SERVED' Button -- click after serving all items
//       >> Firestore 'Orders' database :
//                >> 'isOrderComplete' == true
//                >> 'items' map -- name (string), price (number), quantity (number)

/* IDEA : 

|  <<     Pending Orders     [LOGOUT]   |
_________________________________________
|                                       |
|  Order ID: 001                        |
|  Item: Veggie Burger, Quantity: 2     |
|  Item: Caesar Salad, Quantity: 1      |
|                                       |
|              [SERVED]                 |
|                                       |
-----------------------------------------
|                                       |
|  Order ID: 002                        |
|  Item: Beef Ramen, Quantity: 3        |
|  Item: Fried Rice, Quantity: 2        |
|                                       |
|              [SERVED]                 |
|                                       |
-----------------------------------------
|                                       |
|  Order ID: 003                        |
|  Item: Coke, Quantity: 1              |
|  Item: Garlic Bread, Quantity: 4      |
|                                       |
|              [SERVED]                 |
|                                       |
-----------------------------------------
|               ...                     |
_________________________________________

*/

class Item {
  final String name;
  final int quantity;

  Item({required this.name, required this.quantity});
}

class Order {
  final String orderId;
  final bool isOrderComplete;
  final List<Item> items;

  Order(
      {required this.orderId,
      required this.isOrderComplete,
      required this.items});
}

class OrdersPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final chefID = user?.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ChefHome())),
        ),
        backgroundColor: Colors.redAccent,
        title: Text("Pending Orders",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('isOrderComplete', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs.map((doc) {
            final itemsMap = Map<String, dynamic>.from(doc['items']);
            final List<Item> items = itemsMap.entries.map((entry) {
              return Item(
                  name: entry.value['itemName'],
                  quantity: entry.value['quantity']);
            }).toList();
            return Order(
                orderId: doc.id,
                isOrderComplete: doc['isOrderComplete'],
                items: items);
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order.orderId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in order.items)
                      Text('Item: ${item.name}, Quantity: ${item.quantity}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(order.orderId)
                        .update({
                          'isOrderComplete': true,
                        })
                        .then((_) => print('Order is served: ${order.orderId}'))
                        .catchError(
                            (error) => print('Error updating order: $error'));
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
