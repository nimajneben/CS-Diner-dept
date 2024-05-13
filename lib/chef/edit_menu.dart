import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_item.dart';

// logout button, redirect to login.dart
import 'package:manju_restaurant/pages/login.dart';

/* IDEA : 

<<    Edit Menu Item   [LOGOUT]
______________________________

  (Item 1)       [EDIT]
  .              [DELETE]

  (Item 2)       [EDIT]
  .              [DELETE]

  (Item 3)       [EDIT]
  .              [DELETE]

  (Item 4)       [EDIT]
  .              [DELETE]

 ...

*/

class EditMenu extends StatefulWidget {
  const EditMenu({Key? key}) : super(key: key);

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final chefID = user?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Edit Menu", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_sharp, color: Colors.black, size: 30),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        //  ‘chefID’ field should match the ID of the logged-in user to display their menu items
        stream: FirebaseFirestore.instance
            .collection('Menu')
            .where('chefID', isEqualTo: chefID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final menuItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final menuItem = menuItems[index];
              final itemName = menuItem['itemName'] ?? menuItem['Name'];

              return ListTile(
                title: Text(itemName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMenuItemPage(menuItem: menuItem),
                          ),
                        );
                      },
                      child: const Text('EDIT'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteMenuItem(context, menuItem.id);
                      },
                      child: const Text('DELETE'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  
  void _deleteMenuItem(BuildContext context, String menuItemID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm your action:'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('Menu').doc(menuItemID).delete();
                  Navigator.pop(context);
                } catch (e) {
                  Navigator.pop(context);
                  _showErrorDialog(context, 'Failed to delete the item: ${e.toString()}');
                }
              },
              child: Text('Delete Item'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    } catch (e) {
      _showErrorDialog(context, 'Failed to log out: ${e.toString()}');
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Dismiss', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
