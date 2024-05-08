
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:manju_restaurant/pages/login.dart";


import "../widget/widget_support.dart";
import "food_details.dart";

class SurferHome extends StatefulWidget {
  const SurferHome({super.key});

  @override
  State<SurferHome> createState() => _SurferHomeState();
}

class _SurferHomeState extends State<SurferHome> {

  bool appetizer = false, main = false, dessert = false, soda = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top:30.0, left:20.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello Stranger!",
                style: AppWidget.boldTextFieldStyle(),
              ),

              ///Here is the Login Icon
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn())),
                child: Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: Colors.black, borderRadius: BorderRadius.circular(10.0)
                  ),
                  child:const Icon(Icons.login_outlined, size: 30.0, color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(height: 20.0),
          Text("MANJU",
            style: AppWidget.headLineTextFieldStyle(),
          ),
          Text("Delicious food for you to enjoy",
            style: AppWidget.lightTextFieldStyle(),
          ),
          SizedBox(height: 20.0),
         Container(
           margin: EdgeInsets.only(right: 20.0),
             child: showItems()),
          SizedBox(height: 20.0),

     SingleChildScrollView(
       scrollDirection: Axis.horizontal,
            child: Row(children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      FoodDetails()));
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Image.asset("images/Salad.jpg",
                              height:150,
                              width:150,
                              fit: BoxFit.cover),
                              Text("Mediteranean Salad",
                                style: AppWidget.semiBoldTextFieldStyle(),),
                              SizedBox(height: 5.0),
                              Text("\$8.50",
                                style: AppWidget.semiBoldTextFieldStyle(),)
                        ],
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),

              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(

                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        //need to fix this, the card is not dynamic
                        //enough to handle the text overflow
                        Image.asset("images/Salad.jpg",
                            height:150,
                            width:150,
                            fit: BoxFit.cover),
                        Text("Salad Bowl",
                          style: AppWidget.semiBoldTextFieldStyle(),),
                        SizedBox(height: 5.0),
                        Text("\$8.50",
                          style: AppWidget.semiBoldTextFieldStyle(),)
                      ],
                    )
                ),
              ),
              SizedBox(width: 10.0),

              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Image.asset("images/Salad.jpg",
                            height:150,
                            width:150,
                            fit: BoxFit.cover),
                        Text("Salad Bowl",
                          style: AppWidget.semiBoldTextFieldStyle(),),
                        SizedBox(height: 5.0),
                        Text("\$8.50",
                          style: AppWidget.semiBoldTextFieldStyle(),)
                      ],
                    )
                ),
              ),

            ],),
          ),

          SizedBox(height: 20.0),

          //Here starts the list menu
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("images/Salad.jpg",
                        height:90,
                        width:90,
                        fit: BoxFit.cover),
                    SizedBox(width: 20.0),
                    Column(
                      children:[
                        SizedBox(height: 5.0),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          //handles the text overflow by wrapping the text
                          child: Text("Mediterranean Salad with feta cheese",
                            style: AppWidget.semiBoldTextFieldStyle(),),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          //handles the text overflow by wrapping the text
                          child: Text("\$8.50",
                            style: AppWidget.semiBoldTextFieldStyle(),),
                        ),
                      ]
                    ),
                    
                  ],
                ),
              ),
            ),
          )

        ],


                )
              ),
            );

  }







  Widget showItems(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        //wrap the container with material widget
        //appetizers
        GestureDetector(
          onTap:(){
            appetizer = true;
            main = false;
            dessert = false;
            soda = false;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(2),
                child: Image.asset("images/Salad.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),//Main Course
        GestureDetector(
          onTap:(){
            appetizer = false;
            main = true;
            dessert = false;
            soda = false;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(2),
                child: Image.asset("images/main.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),

        //Desserts
        GestureDetector(
          onTap:(){
            appetizer = false;
            main = false;
            dessert = true;
            soda = false;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(2),
                child: Image.asset("images/dessert.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),
        //Drinks
        GestureDetector(
          onTap:(){
            appetizer = false;
            main = false;
            dessert = false;
            soda = true;
            setState(() {

            });
          },
          child:  Material(
              elevation:5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: appetizer ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(2),
                child: Image.asset("images/soda.jpg", height: 70, width: 70,
                  fit: BoxFit.cover,

                ),
              )),

        ),
      ],
    );
  }
}

