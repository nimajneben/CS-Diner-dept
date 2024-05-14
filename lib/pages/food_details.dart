import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/widget_support.dart';
import "package:manju_three/review/user_ratings.dart";

class FoodDetails extends StatefulWidget {
  final String itemName, imageUrl, description, chef, allergens, chefId;
  final double price, rating;

  FoodDetails({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.description,
    required this.chef,
    required this.allergens,
    required this.chefId,
    required this.price,
    required this.rating,
  });

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  int aNumber = 1;
  double total = 0;

  @override
  void initState() {
    total = widget.price;
    super.initState();
  }

  Future<void> addCartItem() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference cart = FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart');

    return cart.doc(widget.itemName).set({
      'itemName': widget.itemName,
      'imageUrl': widget.imageUrl,
      'chefId': widget.chefId,
      'chef': widget.chef,
      'allergens': widget.allergens,
      'price': widget.price,
      'rating': widget.rating,
      'description': widget.description,
      'quantity': aNumber,
    }).then((value) => print("Item Added")).catchError((error) => print("Failed to add item: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.itemName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.itemName, style: AppWidget.boldTextFieldStyle()),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserRatings(itemName: widget.itemName), // Ensure ReviewPage exists
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow[900]),
                            const SizedBox(width: 5),
                            Text(widget.rating.toStringAsFixed(2), style: AppWidget.semiBoldTextFieldStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.description, style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 10),
              Text("Chef: ${widget.chef}", style: AppWidget.semiBoldTextFieldStyle()),
              const SizedBox(height: 10),
              Text("Allergens: ${widget.allergens}", style: AppWidget.semiBoldTextFieldStyle()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (aNumber > 1) {
                            setState(() {
                              aNumber--;
                              total = widget.price * aNumber;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(aNumber.toString(), style: AppWidget.semiBoldTextFieldStyle( )),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            aNumber++;
                            total = widget.price * aNumber;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Price:", style: AppWidget.boldTextFieldStyle()),
                      Text("\$${total.toStringAsFixed(2)}", style: AppWidget.headLineTextFieldStyle()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    addCartItem();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(width: 10),
                        Icon(Icons.shopping_cart, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}