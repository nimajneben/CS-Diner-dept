import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manju_three/pages/login.dart';
import 'package:manju_three/chef/chef_home.dart';

// SERVE ORDERS --
//       >> Display All Orders (Menu Item Names) -- shows items they're responsible for
//       >> 'SERVED' Button -- click after serving each items
//       >> Firestore 'Orders' database :
//                >> 'isOrderComplete' == true
//                >> 'items' map -- itemName (string), price (number), quantity (number),
//                                  chef (string), chefId (string), isReady (boolean)

class Item {
  final String name;
  final int quantity;
  final String chefId;
  final bool isReady;

  Item(
      {required this.name,
      required this.quantity,
      required this.chefId,
      required this.isReady}
  );
}

class Order {
  final String orderId;
  final bool isOrderComplete;
  final List<Item> items;

  Order(
      {required this.orderId,
      required this.isOrderComplete,
      required this.items}
  );
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
            final List<Item> items = [];
            itemsMap.forEach((key, value) {
              if (value['chefId'] == chefID) {
                items.add(Item(
                  name: value['itemName'],
                  quantity: value['quantity'],
                  chefId: value['chefId'],
                  isReady: value['isReady'],
                ));
              }
            });
            
            return Order(
                orderId: doc.id,
                isOrderComplete: doc['isOrderComplete'],
                items: items);
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final chefItems = order.items;
              
              return ListTile(
                title: Text('Order ID: ${order.orderId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: chefItems
                      .map((item) => Text('Item: ${item.name}, Quantity: ${item.quantity}'))
                      .toList(),
                ),
                trailing: Column(
                  children: chefItems.map((item) {
                    return ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('Orders')
                            .doc(order.orderId)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                Map<String, dynamic> items = documentSnapshot['items'];
                                String itemKey = items.keys.firstWhere(
                                  (k) => items[k]['itemName'] == item.name && items[k]['chefId'] == chefID,
                                  orElse: () => '',
                                );
                                if (itemKey != null) {
                                  items[itemKey]['isReady'] = true;
                                  FirebaseFirestore.instance
                                      .collection('Orders')
                                      .doc(order.orderId)
                                      .update({'items': items}).then((value) {
                                        print('Item is served: ${item.name}');
                                        _checkOrderComplete(order, items);
                                  });
                                }
                              } else {
                                print('Document does not exist on the database');
                              }
                            });
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
    );
  }

  void _checkOrderComplete(Order order, Map<String, dynamic> items) {
    final allItemsReady = items.values.every((item) => item['isReady']);
    if (allItemsReady) {
      FirebaseFirestore.instance
          .collection('Orders')
          .doc(order.orderId)
          .update({
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
