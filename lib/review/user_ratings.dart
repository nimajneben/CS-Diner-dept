// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter/widgets.dart';
import 'package:manju_restaurant/widget/widget_support.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserRatings extends StatefulWidget {
  const UserRatings({super.key});

  @override
  State<UserRatings> createState() => _UserRatingsState();
}

class _UserRatingsState extends State<UserRatings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("User Ratings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40,),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      // Icon(Icons.star, color: Colors.yellow[900], size: 80),
                      Text("4.5", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          RatingBar.builder(
            itemSize: 20,
           initialRating: 4.5,
           minRating: 1,
           direction: Axis.horizontal,
           allowHalfRating: true,
           itemCount: 5,
           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
           itemBuilder: (context, _) => Icon(
             Icons.star,
             color: Colors.amber,
           ),
           onRatingUpdate: (rating) {
             print(rating);
           },
        )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Mediterrian Salad", style: AppWidget.headLineTextFieldStyle()),
                      Text("Chef Gordon Ramsey", style: AppWidget.semiBoldTextFieldStyle()),
                    ],
                  ),
                ],
              ),
          
          
          SizedBox(height: 50,),
        
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Card(
        
                  child: ListTile(
                    
                    tileColor: Colors.grey[100],
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Fardeen Ahmed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),    
                      ),
                      SizedBox(height: 5,),
                      RatingBar.builder(
                               itemSize: 20,
                              initialRating: 4.5,
                               minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                                itemCount: 5,
                               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                    Icons.star,
                               color: Colors.amber,
                     ),
                     onRatingUpdate: (rating) {
                       print(rating);
                     },
                  ),
                  SizedBox(height: 20,),
                  ]),
                  contentPadding: EdgeInsets.all(20),
                  subtitle: Text("The food was amazing, I loved it", style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                ),
                SizedBox(height: 20,),
                Card(
        
                  child: ListTile(
                    
                    
                    tileColor: Colors.grey[100],
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Fardeen Ahmed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),    
                      ),
                      SizedBox(height: 5,),
                      RatingBar.builder(
                               itemSize: 20,
                              initialRating: 4.5,
                               minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                                itemCount: 5,
                               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                    Icons.star,
                               color: Colors.amber,
                     ),
                     onRatingUpdate: (rating) {
                       print(rating);
                     },
                  ),
                  SizedBox(height: 20,),
                  ]),
                  contentPadding: EdgeInsets.all(20),
                  subtitle: Text("The food was amazing, I loved it", style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                ),
        
                SizedBox(height: 20,),
                Card(
        
                  child: ListTile(
                    
                    tileColor: Colors.grey[100],
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Fardeen Ahmed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),    
                      ),
                      SizedBox(height: 5,),
                      RatingBar.builder(
                               itemSize: 20,
                              initialRating: 4.5,
                               minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                                itemCount: 5,
                               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                    Icons.star,
                               color: Colors.amber,
                     ),
                     onRatingUpdate: (rating) {
                       print(rating);
                     },
                  ),
                  SizedBox(height: 20,),
                  ]),
                  contentPadding: EdgeInsets.all(20),
                  subtitle: Text("The food was amazing, I loved it", style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                ),
                 SizedBox(height: 20,),
                 Card(
        
                  child: ListTile(
                    
                    tileColor: Colors.grey[100],
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Fardeen Ahmed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),    
                      ),
                      SizedBox(height: 5,),
                      RatingBar.builder(
                               itemSize: 20,
                              initialRating: 4.5,
                               minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                                itemCount: 5,
                               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                    Icons.star,
                               color: Colors.amber,
                     ),
                     onRatingUpdate: (rating) {
                       print(rating);
                     },
                  ),
                  SizedBox(height: 20,),
                  ]),
                  contentPadding: EdgeInsets.all(20),
                  subtitle: Text("The food was amazing, I loved it", style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                ),
                 
                 
                  
                
              ],
            )
          )
        
          
          ],
          ),
          
        ),
      ),
    );
  }
}
