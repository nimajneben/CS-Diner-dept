import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../methods/data.dart';
import '../widget/widget_support.dart';
import 'cart_details.dart';
import 'food_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool appetizer = false, main = false, dessert = false, soda = false;

  Stream? foodStream;

  ontheload() async {
    foodStream = FirebaseFirestore.instance
        .collection('Menu')
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItems() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetails(
                        itemName: ds['itemName'],
                        imageUrl: ds['imageUrl'],
                        description: ds['description'],
                        chef: ds['chef'],
                        allergens: ds['allergens'],
                        chefId: ds['chefId'],
                        price: ds['price'],
                        rating: ds['rating'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: ds["imageUrl"],
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            ds["itemName"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "\$${ds["price"]}",
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                              const SizedBox(width: 10.0),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                ds['rating'].toStringAsFixed(2),
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: AppWidget.semiBoldTextFieldStyle(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget allItemsVertical() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetails(
                        itemName: ds['itemName'],
                        imageUrl: ds['imageUrl'],
                        description: ds['description'],
                        chef: ds['chef'],
                        allergens: ds['allergens'],
                        chefId: ds['chefId'],
                        price: ds['price'],
                        rating: ds['rating'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20.0, bottom: 30),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: ds["imageUrl"],
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  ds["itemName"],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "\$${ds["price"]}",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: AppWidget.semiBoldTextFieldStyle(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30.0, left: 20.0, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<String>(
                    future: fetchUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text(
                          "Loading...",
                          style: AppWidget.boldTextFieldStyle(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          "Error: ${snapshot.error}",
                          style: AppWidget.boldTextFieldStyle(),
                        );
                      }
                      return Text(
                        "Hello ${snapshot.data}",
                        style: AppWidget.boldTextFieldStyle(),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartDetails(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_checkout,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                "MANJU",
                style: AppWidget.headLineTextFieldStyle(),
              ),
              Text(
                "Delicious food for you to enjoy",
                style: AppWidget.lightTextFieldStyle(),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                child: showItems(),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 200.0,
                child: allItems(),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 300.0,
                child: allItemsVertical(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            appetizer = true;
            main = false;
            dessert = false;
            soda = false;

            foodStream = await DatabaseFunctions().getMenuItems("Appetizers");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: appetizer ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                "images/Salad.jpg",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            appetizer = false;
            main = true;
            dessert = false;
            soda = false;
            foodStream = await DatabaseFunctions().getMenuItems("Main");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: main ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                "images/main.jpg",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            appetizer = false;
            main = false;
            dessert = true;
            soda = false;
            foodStream = await DatabaseFunctions().getMenuItems("Desserts");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: dessert ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                "images/dessert.jpg",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            appetizer = false;
            main = false;
            dessert = false;
            soda = true;
            foodStream = await DatabaseFunctions().getMenuItems("Drinks");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: soda ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                "images/soda.jpg",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}