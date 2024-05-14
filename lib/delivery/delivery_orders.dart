import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

class DeliveryOrderScreen extends StatefulWidget {
  const DeliveryOrderScreen({super.key});
  @override
  State<DeliveryOrderScreen> createState() => _DeliveryOrderScreenState();
}

class _DeliveryOrderScreenState extends State<DeliveryOrderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Delivery Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Orders')
            .where('checkoutMethod.method', isEqualTo: 'Delivery')
            .where('isOrderComplete', isEqualTo: false)
            // .orderBy('orderDate') // TODO: add later when building finishes
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if (!snapshot.hasData) {
            return const Text("no orders");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              List<String> itemList = List<String>.empty(growable: true);
              data.forEach((key, value) {
                if (key == 'items') {
                  List values = value.toList();
                  for (Map<String, dynamic> v in values) {
                    itemList.add(v['itemName']);
                  }
                }
              });

              return ListTile(
                title: Text('Order ID: ${data['orderId']}'),
                subtitle: Text('${itemList.toString()}'), //TODO: add timestamp
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('Complete'),
                      onPressed: () {
                        document.reference
                            .update({'checkoutMethod.deliveryperson': uid});
                        document.reference.update({'isOrderComplete': true});
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
