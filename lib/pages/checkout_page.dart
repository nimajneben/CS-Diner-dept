import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widget/widget_support.dart';

class CheckoutPage extends StatefulWidget {
  final double subtotal;  // Accept subtotal as a parameter
  final bool vip;

  const CheckoutPage({super.key, required this.subtotal, required this.vip});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double taxRate = 0.07; // 7% Tax
  double finalTotal = 0.0;
  final _pickupDateController = TextEditingController();
  final _pickupTimeController = TextEditingController();
  final _dineInDateController = TextEditingController();
  final _dineInTimeController = TextEditingController();
  final _numPeopleController = TextEditingController();
  final _deliveryAddressController = TextEditingController();

  String selectedTab = "Eat In"; // Default selected tab

  // Method to handle updating user data
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
          int newTotalOrders = totalOrders + 1;
          bool newVip = false;

          // Check if the updated deposit is not negative
          if (updatedDeposit < 0) {
            throw Exception("Insufficient funds!");
          }
          if (!widget.vip && (newTotalSpent > 500.0 || newTotalOrders >= 50)) {
            newVip = true;
            transaction.update(userRef, {'isVip': newVip});
          }

          transaction.update(userRef, {
            'wallet': updatedDeposit,
            'totalSpent': newTotalSpent,
            'totalOrders': newTotalOrders
          });
        });
      } catch (e) {
        if (!mounted) return;
        throw Exception('Failed to update user data: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in'), backgroundColor: Colors.red));
    }
  }

  // Method to handle creating orders
  Future<void> createOrder(double total, Map<String, dynamic> checkoutMethod) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Cart')
        .get();

    List<Map<String, dynamic>> items = cartSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        'itemName': data['itemName'],
        'quantity': data['quantity'],
        'price': data['price'],
        'chef': data['chef'],
        'chefId': data['chefId'],
        'isReady': false
      };
    }).toList();

    DocumentReference orderRef = FirebaseFirestore.instance.collection('Orders').doc();

    await orderRef.set({
      'orderId': orderRef.id,
      'customer': user.uid,
      'isOrderComplete': false,
      'totalPrice': total,
      'items': items,
      'checkoutMethod': checkoutMethod, // Add the checkout method details here
      'orderDate': Timestamp.now(), // Add the timestamp here
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Created Successfully')));
  }

  // Method to handle clearing the cart
  Future<void> clearCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    CollectionReference cartRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Cart');
    CollectionReference menuRef = FirebaseFirestore.instance.collection('Menu');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    QuerySnapshot cartSnapshot = await cartRef.get();
    try {
      for (DocumentSnapshot cartDoc  in cartSnapshot.docs) {
        DocumentReference menuDocRef = menuRef.doc(cartDoc.id);
        DocumentSnapshot menuDoc = await menuDocRef.get();

        int numberOfOrders = menuDoc['numberOfOrders'] ?? 0;
        int quantity = cartDoc['quantity'];
        numberOfOrders += quantity;
        // Update the document with the new number of orders
        batch.update(menuDoc.reference, {'numberOfOrders': numberOfOrders});
        batch.delete(cartDoc.reference);
      }
    } catch (e) {
      if (!mounted) return;
      throw Exception('Failed to update user data: $e');
    }

    await batch.commit();
  }

  // Method to build form for date and time input
  Widget buildDateTimeInput(TextEditingController dateController, TextEditingController timeController) {
    return Column(
      children: [
        TextField(
          controller: dateController,
          decoration: const InputDecoration(labelText: 'Date'),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
              });
            }
          },
        ),
        TextField(
          controller: timeController,
          decoration: const InputDecoration(labelText: 'Time'),
          readOnly: true,
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              setState(() {
                timeController.text = pickedTime.format(context);
              });
            }
          },
        ),
      ],
    );
  }

  // Method to build form for dine-in tab
  Widget buildDineInForm() {
    return Column(
      children: [
        buildDateTimeInput(_dineInDateController, _dineInTimeController),
        TextField(
          controller: _numPeopleController,
          decoration: const InputDecoration(labelText: 'Number of People'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Method to build form for delivery tab
  Widget buildDeliveryForm() {
    return Column(
      children: [
        TextField(
          controller: _deliveryAddressController,
          decoration: const InputDecoration(labelText: 'Delivery Address'),
        ),
      ],
    );
  }

  // Method to build cart details for each tab
  Widget buildCartDetails(double subtotal, double tax, double total, {Widget? extraContent}) {
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
                if (extraContent != null) extraContent,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build summary row
  Widget buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppWidget.headLineTextFieldStyle() : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("\$${value.toStringAsFixed(2)}", style: isTotal ? AppWidget.headLineTextFieldStyle() : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Method to build cart items
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
            title: Text(data['itemName'], style: AppWidget.semiBoldTextFieldStyle()),
            subtitle: Text("Quantity: ${data['quantity']}", style: AppWidget.lightTextFieldStyle()),
            trailing: Text("\$${data['price']}", style: AppWidget.semiBoldTextFieldStyle()),
          );
        }).toList();

        return Column(children: cartItems);
      },
    );
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
          bottom: TabBar(
            tabs: const [
              Tab(text: "Eat In"),
              Tab(text: "Pickup"),
              Tab(text: "Delivery"),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  setState(() => selectedTab = "Eat In");
                  break;
                case 1:
                  setState(() => selectedTab = "Pickup");
                  break;
                case 2:
                  setState(() => selectedTab = "Delivery");
                  break;
              }
            },
          ),
          centerTitle: true,
          title: Text('Checkout', style: AppWidget.boldTextFieldStyle()),
        ),
        body: TabBarView(
          children: [
            buildCartDetails(subtotal, tax, finalTotal, extraContent: buildDineInForm()),
            buildCartDetails(subtotal, tax, finalTotal, extraContent: buildDateTimeInput(_pickupDateController, _pickupTimeController)),
            buildCartDetails(subtotal, tax, finalTotal, extraContent: buildDeliveryForm()),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () async {
              if (finalTotal > 0) {
                try {
                  Map<String, dynamic> checkoutMethod = {};

                  switch (selectedTab) {
                    case "Eat In":
                      checkoutMethod = {
                        'method': 'Dine In',
                        'date': _dineInDateController.text,
                        'time': _dineInTimeController.text,
                        'numberOfPeople': _numPeopleController.text,
                      };
                      break;
                    case "Pickup":
                      checkoutMethod = {
                        'method': 'Pickup',
                        'date': _pickupDateController.text,
                        'time': _pickupTimeController.text,
                      };
                      break;
                    case "Delivery":
                      checkoutMethod = {
                        'method': 'Delivery',
                        'address': _deliveryAddressController.text,
                      };
                      break;
                  }

                  await _updateUserData(finalTotal);
                  await createOrder(finalTotal, checkoutMethod);
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
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
              ),
              elevation: 0,
            ),
            child: const Text('Complete Purchase'),
          ),
        ),
      ),
    );
  }
}