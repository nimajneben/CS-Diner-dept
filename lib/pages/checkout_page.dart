
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';

import '../widget/widget_support.dart';

class CheckoutPage extends StatefulWidget {
  final double subtotal;  // Accept subtotal as a parameter

  const CheckoutPage({super.key, required this.subtotal});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage> {

  double taxRate = 0.07; // 7% Tax
  double finalTotal = 0.0;


  Future<void> _updateUserData(double total) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        // Transaction to safely update the deposit
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }
          double currentDeposit = snapshot.get('wallet').toDouble();
          double updatedDeposit = currentDeposit - total;

          double totalSpent = snapshot.get('totalSpent').toDouble();
          double newTotalSpent = totalSpent + total;

          int totalOrders = snapshot.get('totalOrders').toInt();
          int newTotalOrders = totalOrders+1;

          // Check if the updated deposit is not negative
          if (updatedDeposit < 0) {
            throw Exception("Insufficient funds!");
          }

          transaction.update(userRef, {
            'wallet': updatedDeposit,
            'totalSpent': newTotalSpent,
            'totalOrders': newTotalOrders
          });
        });
      } catch (e) {
        // Now, this catch should properly handle exceptions thrown within the transaction
        if (!mounted) return;
        throw Exception('Failed to update user data: $e');
      }
    } else {
      // Handle case where user is null
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in'), backgroundColor: Colors.red));
    }
  }
  Future<void> createOrder(double total) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    // Fetch the cart items
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Cart')
        .get();

    // Map cart items to a new format for storing in the order
    List<Map<String, dynamic>> items = cartSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        'itemName': data['itemName'],
        'quantity': data['quantity'],
        'price': data['price'],
      };
    }).toList();

    // Create the order document with a unique ID
    DocumentReference orderRef = FirebaseFirestore.instance.collection('Orders').doc();

    // Now set the data including the orderID
    await orderRef.set({
      'orderId': orderRef.id, // Use the generated document ID as the orderID
      'customer': user.uid,
      'isOrderComplete': false,
      'totalPrice': total,
      'items': items,
    });

    // Optionally clear the cart or handle other post-purchase logic
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Created Successfully')));
  }

  Future<void> clearCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    CollectionReference cartRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Cart');

    // Get all cart items
    QuerySnapshot cartSnapshot = await cartRef.get();

    // Create a batch to delete all items
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (DocumentSnapshot doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch
    await batch.commit();
  }



  @override
  Widget build(BuildContext context) {
    final subtotal = widget.subtotal; // Use the subtotal passed from the cart page
    final tax = subtotal * taxRate;
    finalTotal = subtotal + tax;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Eat In"),
              Tab(text: "Pickup"),
              Tab(text: "Delivery"),
            ],
          ),
          centerTitle: true,
          title: Text('Checkout', style: AppWidget.boldTextFieldStyle(),),
        ),
        body: TabBarView(
          children: [
            buildCartDetails(subtotal, tax, finalTotal),
            buildCartDetails(subtotal, tax, finalTotal),
            buildCartDetails(subtotal, tax, finalTotal),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60, // Adjust the height as necessary
          width: double.infinity,
          padding: const EdgeInsets.all(8), // Padding around the button
          child: ElevatedButton(
            onPressed: ()async {
              if (finalTotal > 0) {
                try {
                  await _updateUserData(finalTotal);
                  await createOrder(finalTotal);
                  await clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Purchase completed successfully!'),
                      backgroundColor: Colors.green));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error completing purchase: $e'),
                      backgroundColor: Colors.red));
                }
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Make the button corners squared
            ), // Text color
              textStyle: const TextStyle(
                fontSize: 16,
              ),
              elevation: 0, // Removes shadow for a flatter appearance
            ),
            child: const Text('Complete Purchase'),
          ),
        ),
      ),
    );
  }

  Widget buildCartDetails(double subtotal, double tax, double total) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildCartItems(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSummaryRow("Subtotal", subtotal),
                buildSummaryRow("Tax", tax),
                buildSummaryRow("Total", total, isTotal: true), // Style differently if needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppWidget.headLineTextFieldStyle() : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("\$${value.toStringAsFixed(2)}", style: isTotal ? AppWidget.headLineTextFieldStyle() : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildCartItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Cart').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return const Text("No items in cart");
        }

        List<Widget> cartItems = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ListTile(
            leading: Image.network(data['imageUrl'], width: 100, fit: BoxFit.cover),
            title: Text(data['itemName'],style: AppWidget.semiBoldTextFieldStyle()),
            subtitle: Text("Quantity: ${data['quantity']}", style: AppWidget.lightTextFieldStyle()),
            trailing: Text("\$${data['price']}", style: AppWidget.semiBoldTextFieldStyle(),),
          );
        }).toList();


        return Column(children: cartItems);
      },
    );
  }
}