import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/widget_support.dart';
import 'order_details.dart'; // Ensure correct path

class CustomerOrder extends StatefulWidget {
  const CustomerOrder({super.key});

  @override
  State<CustomerOrder> createState() => _CustomerOrderState();
}

class _CustomerOrderState extends State<CustomerOrder> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<List<Map<String, dynamic>>> fetchOrdersByCustomer(String customerId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where('customer', isEqualTo: customerId)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Your Orders", style: AppWidget.headLineTextFieldStyle()),
              ),
              user != null ? buildUserOrders(context, user!.uid) : const Text("Please log in to view orders."),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserOrders(BuildContext context, String userId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchOrdersByCustomer(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.data!.isEmpty) {
          return const Text('No orders found for this user.');
        }
        // Filter orders into active and completed
        List<Map<String, dynamic>> activeOrders = snapshot.data!.where((order) => order['isOrderComplete'] == false).toList();
        List<Map<String, dynamic>> completedOrders = snapshot.data!.where((order) => order['isOrderComplete'] == true).toList();

        return Column(
          children: [
            ordersListSection("Active Orders", activeOrders ),
            ordersListSection("Completed Orders", completedOrders),
          ],
        );
      },
    );
  }

  Widget ordersListSection(String title, List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text('$title: None', style: const TextStyle(fontStyle: FontStyle.italic)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return ListTile(
              title: Text("Order ID: ${order['orderId']}"),
              subtitle: Text('Total: \$${order['totalPrice'].toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetails(orderId: order['orderId'], items: order['items'], isOrderComplete: order['isOrderComplete'],totalPrice: order['totalPrice'],),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}