// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manju_restaurant/chef/chef_bottomnav.dart';
import 'package:manju_restaurant/methods/data.dart';
import 'package:manju_restaurant/widget/widget_support.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({super.key});

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {

String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


  final List<String> categories = ["Appitizers", "Main", "Dessert", "Drinks"];
  String? value;

  TextEditingController itemName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController allergens = TextEditingController();

  TextEditingController description = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  User? user = FirebaseAuth.instance.currentUser;
  
  Future getImage() async
  {
    var image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,);

    selectedImage = File(image!.path);
    setState(() {
      
    });
  }
 

  // Future uploadItem() async
  uploadItem() async {

    String? chefId = user!.uid;
    String? chefName = await DatabaseFunctions().getChefName(chefId);
    double? priceValue = double.tryParse(price.text.trim());
if (priceValue == null) {
  // Handle error, inform user to input correct format
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Please enter a valid price"),
    backgroundColor: Colors.red,
  ));
  return; // Exit function if price is not valid
}


    if(selectedImage != null && itemName != "" && price != "" && allergens != "" && description != "" && value != null)
    {
     String addId = getRandomString(10);

     Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("menuItems").child(addId);

     final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

     var downloadUrl = await (await task).ref.getDownloadURL();
    

    Map<String, dynamic> itemData = {
      "itemName": itemName.text.trim(),
      "price": double.parse(price.text.trim()),
      "allergens": allergens.text.trim(),
      "description": description.text.trim(),
      "category": value,
      "imageUrl": downloadUrl,
      "rating": 0.0,
      "numberOfOrders": 0,
      "numberOfReviews": 0,
      "chef": chefName,
      "chefId": chefId,
      
    };

    await DatabaseFunctions().addMemuItem(itemData).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        
        backgroundColor: Colors.greenAccent,
        content: Text("Item Added Successfully", style: AppWidget.semiBoldTextFieldStyle(),),),
    );});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChefNav()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: Text("Add Menu Item", style: AppWidget.boldTextFieldStyle(),), 
        
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            //Item image goes here.
            
            children: [
                  Text("Upload the Image of the Menu Item", style: AppWidget.semiBoldTextFieldStyle(),),
                SizedBox(height: 20),
                  selectedImage == null ? GestureDetector(
                      onTap: (){
                        getImage();
                      },

                    child: Center(
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.add_a_photo, size: 30, color: Colors.black,),
                      ),
                    ),
                                    ),
                  ):  Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(selectedImage!, fit: BoxFit.cover,)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
        
                //Item Name goes here.
                ////////////////////////
        
        
                Text("Item Name:", style: AppWidget.semiBoldTextFieldStyle(),),
                SizedBox(height: 10),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
        
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
        
                  child: TextFormField(
                    controller: itemName,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Item Name",
                      hintStyle: AppWidget.lightTextFieldStyle(),
                    ),
                  ),
        
                  
                ),
        
                /**
                 * 
                 * Price goes here
                 * 
                 * 
                 */
                SizedBox(height: 30),
                Text("Price:", style: AppWidget.semiBoldTextFieldStyle(),),
                SizedBox(height: 10),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
        
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
        
                  child: TextFormField(
                    controller: price,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: "Enter Price",
                      hintStyle: AppWidget.lightTextFieldStyle(),
                    ),
                  ),
        
                  
                ), 
        
                 SizedBox(height: 30),
                Text("Item Description:", style: AppWidget.semiBoldTextFieldStyle(),),
                SizedBox(height: 10),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
        
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
        
                  child: TextFormField(
                    maxLines:5, 
                    controller: description,
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: "Item Description",
                      hintStyle: AppWidget.lightTextFieldStyle(),
                    ),
                  ),
        
                  
                ),

                /**
                 * 
                 * 
                 * Allergens goes here
                 */

                 SizedBox(height: 30),
              Text("Allergens:", style: AppWidget.semiBoldTextFieldStyle(),),
              SizedBox(height: 10),
              Container(
                padding:EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TextFormField(
                  controller: allergens,
                  decoration: InputDecoration(
                    
                    border: InputBorder.none,
                    hintText: "Enter Allergens",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                  ),
                ),

                
              ), 
 
        
        
        
                /**
                 * 
                 * Categories goes here
                 * 
                 * 
                 */
                SizedBox(height: 30), 
                Text("Select Category:", style: AppWidget.semiBoldTextFieldStyle(),),
              SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(child: 
                  DropdownButton<String>(
                      items: categories.map((item) => DropdownMenuItem<String>(child: 
                      Text(item,
                      style: AppWidget.semiBoldTextFieldStyle(),
                      ), value: item,)).toList(),
                      onChanged: ((value) => setState(() => this.value = value)),
                      dropdownColor: Colors.grey[200],
                      hint: Text("Select Category", style: AppWidget.lightTextFieldStyle(),),
                      iconSize: 30,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      value: value,



                  ),
                  ),
                  
                  
                  ),


                  /*
                  Add Button goes here
                  
                  */
                  SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: (){
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )

                  
            ],
          ),
        
        ),
      )

    );
  }
}