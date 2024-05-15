import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/material.dart%20";
import "package:manju_three/methods/data.dart";
import "package:manju_three/pages/login.dart";

import "../widget/widget_support.dart";
import "food_details.dart";

class SurferHome extends StatefulWidget {
  const SurferHome({super.key});

  @override
  State<SurferHome> createState() => _SurferHomeState();
}

class _SurferHomeState extends State<SurferHome> {
  bool appetizer = false, main = false, dessert = false, soda = false;

  Stream? foodStream;

  void _searchItem(String query) {
    if (query.isNotEmpty) {
      Stream<QuerySnapshot> newStream = FirebaseFirestore.instance
          .collection('Menu')
          .where('itemName', isGreaterThanOrEqualTo: query)
          .where('itemName', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots();

      setState(() {
        foodStream = newStream;
      });
    } else {
      // Reset to default stream if search query is cleared
      ontheload(); // This resets to your default stream
    }
  }

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
                // itemCount: 3,
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
                                    itemName: ds[
                                        'itemName'], // Assuming 'itemName' is the field name in your document
                                    imageUrl: ds['imageUrl'],
                                    description: ds['description'],
                                    chef: ds['chef'],
                                    allergens: ds['allergens'],
                                    chefId: ds['chefId'],
                                    price: ds['price'],
                                    rating: ds['rating'],
                                  )));
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
                                // Image.network(ds["imageUrl"],
                                //     cacheHeight:100,
                                //     cacheWidth:100,
                                //     fit: BoxFit.cover),
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
                                  ),
                                ),
                                Text(
                                  ds["itemName"],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                const SizedBox(height: 5.0),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "\$${ds["price"]}",
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Icon(Icons.star,
                                        color: Colors.yellow[800], size: 20.0),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(ds['rating'].toString(),
                                        style:
                                            AppWidget.semiBoldTextFieldStyle()),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                  );
                });
          }
          {
            // return
            return Text(
              "No data found",
              style: AppWidget.semiBoldTextFieldStyle(),
            );
          }
        });
  }

  Widget allItemsVertical() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
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
                                      itemName: ds[
                                          'itemName'], // Assuming 'itemName' is the field name in your document
                                      imageUrl: ds['imageUrl'],
                                      description: ds['description'],
                                      chef: ds['chef'],
                                      allergens: ds['allergens'],
                                      chefId: ds['chefId'],
                                      price: ds['price'],
                                      rating: ds['rating'],
                                    )));
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
                                // Image.asset("assets/images/Salad.jpg",
                                //     cacheHeight:90,
                                //     cacheWidth:90,
                                //     fit: BoxFit.cover),

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
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Column(children: [
                                  const SizedBox(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //handles the text overflow by wrapping the text
                                    child: Text(
                                      ds["itemName"],
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    //handles the text overflow by wrapping the text
                                    child: Text(
                                      "\$${ds["price"]}",
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANJU'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.login),
              tooltip: 'Login',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LogIn()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 30.0, left: 20.0, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  "Hi, stranger!",
                  style: AppWidget.headLineTextFieldStyle(),
                ),
                Text(
                  "Delicious food for you to enjoy.\nMake an account today!",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 20.0),
                Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: showItems()),
                const SizedBox(height: 20.0),

                SizedBox(height: 200.0, child: allItems()),

                const SizedBox(height: 20.0),

                //Here starts the list menu
                Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    height: 300.0,
                    child: allItemsVertical()),
              ],
            )),
      ),
    );
  }

  Widget showItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //wrap the container with material widget
        //appetizers
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
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  "assets/images/Salad.jpg",
                  cacheHeight: 70,
                  cacheWidth: 70,
                  fit: BoxFit.cover,
                ),
              )),
        ), //Main Course
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
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  "assets/images/main.jpg",
                  cacheHeight: 70,
                  cacheWidth: 70,
                  fit: BoxFit.cover,
                ),
              )),
        ),

        //Desserts
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
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  "assets/images/dessert.jpg",
                  cacheHeight: 70,
                  cacheWidth: 70,
                  fit: BoxFit.cover,
                ),
              )),
        ),
        //Drinks
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
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  "assets/images/soda.jpg",
                  cacheHeight: 70,
                  cacheWidth: 70,
                  fit: BoxFit.cover,
                ),
              )),
        ),
      ],
    );
  }
}
