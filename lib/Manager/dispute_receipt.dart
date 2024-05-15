import 'package:flutter/material.dart';

class DisputeReceipt extends StatelessWidget {
  final String name;
  final DateTime date;
  final String location;
  final String address;
  final String address2;
  final String description;
  final String dispute;

  DisputeReceipt({
    required this.name,
    required this.date,
    required this.location,
    required this.address,
    required this.address2,
    required this.description,
    required this.dispute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispute Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name', style: TextStyle(fontSize: 20)),
            Text('Date: ${date.month}/${date.day}/${date.year}',
                style: TextStyle(fontSize: 20)),
            Text('Status: $address2',
                style: TextStyle(fontSize: 20)),
            Text('Location: $location', style: TextStyle(fontSize: 20)),
            Text('Address Dispute To: $address',
                style: TextStyle(fontSize: 20)),
            Text('Description: $description', style: TextStyle(fontSize: 20)),
            Text('Dispute: $dispute', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
