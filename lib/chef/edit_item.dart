import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// logout button, redirect to login.dart
import 'package:manju_restaurant/pages/login.dart';

/* IDEA : 

<<   Edit Menu Item   [LOGOUT]
______________________________

Category:       [Input Field]
Allergens:      [Input Field]
Description:    [Input Field]
Item Name:      [Input Field]
Price:          [Input Field]

.         [Image]
(Click to upload/change image)

.  [SAVE]         [CANCEL]

*/


class EditMenuItemPage extends StatefulWidget {
  final DocumentSnapshot menuItem;
  EditMenuItemPage({required this.menuItem});

  @override
  _EditMenuItemPageState createState() => _EditMenuItemPageState();
}

class _EditMenuItemPageState extends State<EditMenuItemPage> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _allergensController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    // init text controllers with previous existing data
    _imageUrl = widget.menuItem['imageUrl'];
    _categoryController.text = widget.menuItem['category'] ?? '';
    _allergensController.text = widget.menuItem['allergens'] ?? '';
    _descriptionController.text = widget.menuItem['description'] ?? '';
    _itemNameController.text = widget.menuItem['itemName'] ?? '';
    _priceController.text = widget.menuItem['price']?.toString() ?? '';
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('menuItems/${widget.menuItem.id}.jpg');
        await storageRef.putFile(File(pickedFile.path));
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      } else {
        setState(() {
          _imageUrl = widget.menuItem['imageUrl'];
        });
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_sharp, color: Colors.black, size: 30),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              } catch (e) {
                _showErrorDialog(context, e.toString());
              }
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: _allergensController,
              decoration: InputDecoration(labelText: 'Allergens'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateMenuItem();
                Navigator.pop(context);
              },
              child: Text('SAVE'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMenuItem() {
    try {
      final updatedData = {
        'category': _categoryController.text,
        'allergens': _allergensController.text,
        'description': _descriptionController.text,
        'imageUrl': _imageUrl,
        'itemName': _itemNameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
      };

      FirebaseFirestore.instance
          .collection('Menu')
          .doc(widget.menuItem.id)
          .update(updatedData);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Oh snap!'),
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