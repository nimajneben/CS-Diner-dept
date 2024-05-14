import 'package:flutter/material.dart';

class Receipt extends StatelessWidget {
  final String name;
  final DateTime date;
  final String location;
  final String address;
  final String address2;
  final String description;
  final String accuseName; // New field

  Receipt({
    required this.name,
    required this.date,
    required this.location,
    required this.address,
    required this.address2,
    required this.description,
    required this.accuseName, // New field
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Receipt'),
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
                style: TextStyle(fontSize: 20)), // New field
            Text('Location: $location', style: TextStyle(fontSize: 20)),
            Text('Address Complain To: $address',
                style: TextStyle(fontSize: 20)),
            Text('Description: $description', style: TextStyle(fontSize: 20)),
            Text('Accused: $accuseName', style: TextStyle(fontSize: 20)), // Display the new field
          ],
        ),
      ),
    );
  }
}
