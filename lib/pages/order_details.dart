
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:manju_three/review/add_ratings.dart";

class OrderDetails extends StatefulWidget {
  final String orderId;
  final List items;
  final bool isOrderComplete;
  final double totalPrice;
  final Map<String,dynamic> checkoutMethod;
  final Timestamp orderDate;

  const OrderDetails(
      {super.key, required this.orderId, required this.items, required this.isOrderComplete, required this.totalPrice, required this.checkoutMethod, required this.orderDate});

  @override
  _OrderDetailsState  createState() => _OrderDetailsState();
}
class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Order Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isOrderComplete ? Icons.check_circle : Icons.hourglass_empty,
                    color: widget.isOrderComplete ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.isOrderComplete ? 'Completed' : 'In Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.isOrderComplete ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                var item = widget.items[index];
                return ListTile(
                  title: Text(item['itemName']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('\$${(item['price'] as double).toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
                );
              },
            ),

            const Divider(),
            buildCheckoutMethodDetails(widget.checkoutMethod),
            const Divider(),
            if (widget.isOrderComplete) buildReviewButtons(widget.checkoutMethod),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: \$${widget.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckoutMethodDetails(Map<String, dynamic> checkoutMethod) {
    String method = checkoutMethod['method'];
    switch (method) {
      case 'Dine In':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Method: $method', style: const TextStyle(fontSize: 16)),
              Text('Date: ${checkoutMethod['date']}', style: const TextStyle(fontSize: 16)),
              Text('Time: ${checkoutMethod['time']}', style: const TextStyle(fontSize: 16)),
              Text('Number of People: ${checkoutMethod['numberOfPeople']}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      case 'Pickup':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Method: $method', style: const TextStyle(fontSize: 16)),
              Text('Date: ${checkoutMethod['date']}', style: const TextStyle(fontSize: 16)),
              Text('Time: ${checkoutMethod['time']}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      case 'Delivery':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Method: $method', style: const TextStyle(fontSize: 16)),
              Text('Address: ${checkoutMethod['address']}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      default:
        return const SizedBox.shrink(); // Return an empty widget if no method matches
    }
  }
  Widget buildReviewButtons(Map<String, dynamic> checkoutMethod) {
    String method = checkoutMethod['method'];
    bool isDelivery = method == 'Delivery';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddRatings(checkoutMethod:widget.checkoutMethod , items: widget.items,deliverer: false,)));
            },
            child: const Text("Chef Review"),
          ),
          ElevatedButton(
            onPressed: isDelivery ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddRatings(checkoutMethod:widget.checkoutMethod , items: widget.items,deliverer: true,)));
            } : null,
            style: ElevatedButton.styleFrom(
              disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Disabled button color
            ),
            child: const Text("Delivery Review"),
          ),
        ],
      ),
    );
  }
}