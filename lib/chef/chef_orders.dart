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
//                >> 'items' map -- itemName (string), price (number), quantity (number), 
//                                  chef (string), chefId (string), isReady (boolean)


class Item {
  final String name;
  final int quantity;
  final String chef;
  final bool isReady;

  Item({required this.name, required this.quantity, required this.chef, required this.isReady});
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
                  quantity: entry.value['quantity'],
                  chef: entry.value['chef'],
                  isReady: entry.value['isReady']);
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
              final chefItems = order.items.where((item) => item.chef == chefID).toList(); // TODO: Validate this @Juana?
              
              return ListTile(
                title: Text('Order ID: ${order.orderId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in chefItems)
                      Text('Item: ${item.name}, Quantity: ${item.quantity}'),
                  ],
                ),
                trailing: Column(
                  children: chefItems.map((item) {
                    return ElevatedButton(
                    onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(order.orderId)
                        .update({
                          'items.${item.name}.isReady': true,
                        })
                        .then((_) => {
                              print('Item is served: ${item.name}');
                              _checkOrderComplete(order);
                        })
                        .catchError(
                            (error) => print('Error updating item: $error'));
                    },
                    child: Text('SERVED'),
                );
              }).toList(),
            ),
          );
        },
      );
     },
    ),
  }

  void _checkOrderComplete(Order order) {
    final allItemsReady = order.items.every((item) => item.isReady);
    if (allItemsReady) {
      FirebaseFirestore.instance.collection('Orders').doc(order.orderId).update({
        'isOrderComplete': true,
      })
      .then((_) => print('Order is complete: ${order.orderId}'))
      .catchError((error) => print('Error updating order: $error'));
    }
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
