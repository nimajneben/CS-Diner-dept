import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
late Future<List<Ingredient>> ingredientList;

//Importer Ingredients Main Screen Widget
class ImporterIngredientsView extends StatelessWidget {
  const ImporterIngredientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Available Ingredients')),
      body: const ImporterIngredientsList(),
      floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Scaffold.of(context).showBottomSheet((BuildContext context) {
                  return (ingredientBottomSheet(context, false));
                });
              })),
    );
  }
}

const snackBar = SnackBar(content: Text('Adding ingredient!'));

// Importer Ingredients Stateful Helper
// Return the Ingredients List
class ImporterIngredientsList extends StatefulWidget {
  const ImporterIngredientsList({super.key});

  @override
  State<ImporterIngredientsList> createState() => _ImporterIngredientsList();
}

// Ingredients List Builder
class _ImporterIngredientsList extends State<ImporterIngredientsList> {
  @override
  Widget build(BuildContext context) {
    ingredientList = getDatafromFireStore();
    return FutureBuilder(
      // FutureBuilder
      // Show spinner while contents load
      future: ingredientList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot);
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              // parameter may be null, assert the possibility and provide base case.
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final String name = snapshot.data?[index].name ?? '';
                final int amount = snapshot.data?[index].amount ?? 0;
                final bool restock = snapshot.data?[index].restock ?? false;
                return ListTile(
                  title: Text(name),
                  subtitle: Text(
                      '$amount in stock, restock ${restock ? 'needed' : 'not needed'}'),
                  onTap: () => {
                    Scaffold.of(context).showBottomSheet((context) {
                      return (ingredientBottomSheet(
                          context, true, name, amount, restock));
                    })
                  },
                  onLongPress: () => _deleteDialogBuilder(context, name),
                );
              },
            );
          } else {
            return const Center(child: Text('no items!'));
          }
        } else if (snapshot.hasError) {
          return const Center(child: Text('error retrieving items'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

// In-App Ingredient Object Representation
class Ingredient {
  final String name;
  final int amount;
  final bool restock;

  Ingredient({
    required this.name,
    required this.amount,
    required this.restock,
  });
}

Widget ingredientBottomSheet(BuildContext context, bool edit_mode,
    [String? name, int? amount, bool? restock]) {
  name ??= '';
  amount ??= 0;
  restock ??= false;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
      height: 210,
      color: Colors.transparent,
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
            if (!edit_mode)
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Ingredient Name'),
              )
            else
              Text('$name', style: Theme.of(context).textTheme.headlineMedium),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(label: Text('Quantity')),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(16.0), child: Text('Restock?')),
                  Switch(
                      value: restock ??= false,
                      onChanged: (bool value) {
                        setState(() {
                          restock = value;
                          if (edit_mode) {
                            updateFireStore('$name', null, restock);
                            getDatafromFireStore();
                          }
                        });
                      }),
                ]),
            if (edit_mode) const Text('Data is automatically updated.'),
            if (edit_mode)
              ElevatedButton(
                child: const Text('Delete Ingredient'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDialogBuilder(context, '$name');
                },
              ),
            if (!edit_mode)
              ElevatedButton(
                child: const Text('Add Ingredient'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
          ])),
    );
  });
}

Future<void> _deleteDialogBuilder(BuildContext context, final String name) {
  return showDialog<void>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text(name),
          content: const Text('Delete this ingredient?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deletefromFireStore(name);
                getDatafromFireStore();
              },
            )
          ],
        );
      }));
}

// Get Ingredients Collection from Firebase
Future<List<Ingredient>> getDatafromFireStore() async {
  List<Ingredient> ingredientList = [];
  await db.collection("Ingredients").get().then(
    (querySnapshot) {
      // DEBUG: success message
      // print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        // DEBUG: print data
        // print('${docSnapshot.id} => ${docSnapshot.data()}');
        // Extract data from query
        final String ingredientName = docSnapshot.id;
        final Map<String, dynamic> idmap = docSnapshot.data();
        // Serialization to our Ingredient Object
        ingredientList.add(Ingredient(
            name: ingredientName,
            amount: int.parse(idmap['amount'].toString()),
            restock: bool.parse(idmap['needRestock'].toString())));
      }
    },
    // DEBUG: For error
    // onError: (e) => print("Error completing: $e"),
  );
  return ingredientList;
}

void updateFireStore(String name, [int? amount, bool? needRestock]) {
  if (amount != null) {
    db.collection("Ingredients").doc(name).update({'amount': amount});
    // print('updated amount');
  }
  if (needRestock != null) {
    db.collection("Ingredients").doc(name).update({'needRestock': needRestock});
    // print('updated bool');
  }
}

void deletefromFireStore(String name) {
  db.collection("Ingredients").doc(name).delete();
}

void addtoFireStore(String name, int amount, bool needsRestock) {
  final tempArray = <String, String>{
    "amount": amount.toString(),
    "needRestock": needsRestock.toString()
  };
  db.collection("Ingredients").doc(name).set(tempArray);
}
