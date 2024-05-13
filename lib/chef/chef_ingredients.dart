import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// logout button, redirect to login.dart
import 'package:manju_restaurant/pages/login.dart';

// CHEFS MANUALLY UPDATE INGREDIENTS
//       >> Display Ingredients
//       >> Integer Input & 'GET' Button
//       >> Firestore 'Ingredients' database : 
//                >> 'amount' increases by integer value
//                >> 'needRestock' == true, if false 

/* IDEA : 

<<   Ingredients Inventory   [LOGOUT]
____________________________________

ID: (Ingredient1)
Amount: (15)
Need Restock: (true)
Input Field: [ int ]   [GET]

ID: (Ingredient2)
Amount: (3)
Need Restock: (false)
Input Field: [ int ]   [GET]

ID: (Ingredient3)
Amount: (23)
Need Restock: (true)
Input Field: [ int ]   [GET]

... [ cont'd list of ingredients    ]
... [ from 'Ingredients' collection ]

*/


class ChefIngredient {
  final String id;
  final int amount;
  final bool needRestock;

  ChefIngredient({required this.id, required this.amount, required this.needRestock});

  factory ChefIngredient.fromDocument(DocumentSnapshot doc) {
    return ChefIngredient(
      id: doc.id,
      amount: doc['amount'],
      needRestock: doc['needRestock'],
    );
  }
}

class IngredientModel extends ChangeNotifier {
  int _inputValue = 0;

  int get inputValue => _inputValue;

  void updateInputValue(int newValue) {
    _inputValue = newValue;
    notifyListeners();
  }
}

class ChefIngredientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingredientModel = context.watch<IngredientModel>();
    final user = FirebaseAuth.instance.currentUser;

    // redirect to login page if user isn't a chef? 
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data?.data()?['role'] != 'chef') {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LogIn()),
            );
          });
          return Container();
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text("Ingredients Inventory", style: TextStyle(fontWeight: FontWeight.bold)),
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
            stream: FirebaseFirestore.instance.collection('Ingredients').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final ingredients = snapshot.data!.docs.map((doc) => ChefIngredient.fromDocument(doc)).toList();

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
                    trailing: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final parsedValue = int.tryParse(value) ?? 0;
                            ingredientModel.updateInputValue(parsedValue);
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final inputValue = ingredientModel.inputValue;
                            FirebaseFirestore.instance
                                .collection('Ingredients')
                                .doc(ingredient.id)
                                .update({
                                  'amount': FieldValue.increment(inputValue),
                                  'needRestock': (ingredient.amount + inputValue) < 10,   // true if new amount < 10
                                })
                                .then((_) => print('Inventory updated successfully'))
                                .catchError((error) => print('Error updating inventory: $error'));
                          },
                          child: Text('GET'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}