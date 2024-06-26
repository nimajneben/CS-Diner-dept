import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manju_three/pages/login.dart';

class ChefIngredient {
  final String id;
  final int amount;
  final bool needRestock;

  ChefIngredient(
      {required this.id, required this.amount, required this.needRestock});

  factory ChefIngredient.fromDocument(DocumentSnapshot doc) {
    return ChefIngredient(
      id: doc.id,
      amount: doc['amount'],
      needRestock: doc['needRestock'],
    );
  }
}

class ChefIngredientsPage extends StatefulWidget {
  @override
  _ChefIngredientsPageState createState() => _ChefIngredientsPageState();
}

class _ChefIngredientsPageState extends State<ChefIngredientsPage> {
  int _inputValue = 0;
  void updateInputValue(String value) {
    setState(() {
      _inputValue = int.tryParse(value) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.redAccent,
        title: Text("Request Ingredients",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_sharp, color: Colors.black, size: 30),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Ingredients').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final ingredients = snapshot.data!.docs
              .map((doc) => ChefIngredient.fromDocument(doc))
              .toList();

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return ListTile(
                  title: Text('ID: ${ingredient.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: ${ingredient.amount}'),
                      Text('Need Restock: ${ingredient.needRestock}'),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 150,
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) => updateInputValue(value),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Ingredients')
                                  .doc(ingredient.id)
                                  .update({
                                    'amount': FieldValue.increment(_inputValue),
                                    'needRestock':
                                        (ingredient.amount + _inputValue) <
                                            10, // true if new amount < 10
                                  })
                                  .then((_) =>
                                      print('Inventory updated successfully'))
                                  .catchError((error) => print(
                                      'Error updating inventory: $error'));
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
