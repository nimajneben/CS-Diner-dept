import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter/widgets.dart';

import '../widget/widget_support.dart';

class FoodDetails extends StatefulWidget {
  String itemName, imageUrl, description, chef, allergens, chefId;
  double price, rating;
  FoodDetails(
      {super.key,
      required this.itemName,
      required this.imageUrl,
      required this.description,
      required this.chef,
      required this.allergens,
      required this.chefId,
      required this.price,
      required this.rating});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  int aNumber = 1;
  double total = 0;

  @override
  void initState() {
    // TODO: implement initState
    total = widget.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Detail')),
      body: Container(
        margin: EdgeInsets.only(top: 30, left: 10, right: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            fit: BoxFit.fill,
          ),
          // Image.asset("images/Salad.jpg",
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height/2.5,
          // fit:BoxFit.fill,),
          SizedBox(
            height: 20,
          ),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.itemName, style: AppWidget.boldTextFieldStyle()),
                ],
              ),
              //Spacer() +> ensures maximum space between the two widgets
              Spacer(),

              //Here lies the subtract button
              GestureDetector(
                onTap: () {
                  if (aNumber > 1) {
                    --aNumber;
                    total = total - widget.price;
                    setState(() {});
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(aNumber.toString(),
                  style: AppWidget.semiBoldTextFieldStyle()),
              SizedBox(
                width: 20,
              ),

              //Here lies the add button
              GestureDetector(
                onTap: () {
                  ++aNumber;
                  total = widget.price * aNumber;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow[900],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.rating.toString(),
                      style: AppWidget.semiBoldTextFieldStyle()),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.description,
            style: AppWidget.lightTextFieldStyle(),
            maxLines: 3,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Chef: " + widget.chef,
              style: AppWidget.semiBoldTextFieldStyle()),
          SizedBox(
            height: 20,
          ),
          Text("Allergens: " + widget.allergens,
              style: AppWidget.semiBoldTextFieldStyle()),
          SizedBox(
            height: 20,
          ),
          Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Price:",
                            style: AppWidget.boldTextFieldStyle()),
                        Text("\$" + total.toStringAsFixed(2),
                            style: AppWidget.headLineTextFieldStyle())
                      ]),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Add to Cart",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        ],
                      ))
                ]),
          )
        ]),
      ),
    );
  }
}
