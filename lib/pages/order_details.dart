import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  final String orderId;
  final List items;
  final bool isOrderComplete;
  final double totalPrice;

  const OrderDetails({super.key, required this.orderId, required this.items, required this.isOrderComplete, required this.totalPrice});

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
                    isOrderComplete ? Icons.check_circle : Icons.hourglass_empty,
                    color: isOrderComplete ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isOrderComplete ? 'Completed' : 'In Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isOrderComplete ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return ListTile(
                  title: Text(item['itemName']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('\$${(item['price'] as double).toStringAsFixed(2)}'),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
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
}
