
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter/widgets.dart';

import '../widget/widget_support.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({super.key});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  int aNumber = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:  EdgeInsets.only(top: 30, left: 10, right: 20),
        child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Column(children: [Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black)])),
            Image.asset("images/Salad.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.5,
            fit:BoxFit.fill,),
            SizedBox(height: 20,),


            Row(

              children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mediteranean Salad",
                      style: AppWidget.boldTextFieldStyle()),
                ],
              ),
            //Spacer() +> ensures maximum space between the two widgets
              Spacer(),

                //Here lies the subtract button
                GestureDetector(
                  onTap: (){
                    if(aNumber>1){
                      --aNumber;
                      setState(() {

                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black, borderRadius: BorderRadius.circular(10)),
                   child: Icon(Icons.remove, color: Colors.white,
                   ),

                    ),

              ),
                SizedBox(width: 20,),
                Text(aNumber.toString(), style: AppWidget.semiBoldTextFieldStyle()),
                SizedBox(width: 20,),

                //Here lies the add button
                GestureDetector(
                  onTap: (){
                    ++aNumber;
                    setState(() {

                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.add, color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20,),


            ],),
            SizedBox(height: 20,),
            Row(
              children: [

                  
                    
                    Row(children: [Icon(Icons.star, color: Colors.yellow[900],),
                    SizedBox(width: 5,),
                    Text("4.5", style: AppWidget.semiBoldTextFieldStyle()),],),
                  

              ],),
            SizedBox(height: 20,),
            Text("lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                style: AppWidget.lightTextFieldStyle(),
            maxLines: 3,),
            SizedBox(height: 20,),
            Text("Chef: John Doe", style: AppWidget.semiBoldTextFieldStyle()),
            SizedBox(height: 20,),
            Text("Allergens: Gluten, Soy, Nuts",
                style: AppWidget.semiBoldTextFieldStyle()),
            SizedBox(height: 20,),
            Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children:[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Total Price:",
                        style: AppWidget.boldTextFieldStyle()),
                    Text("\$12.00", style: AppWidget.headLineTextFieldStyle())
                  ]
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2.5,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Add to Cart",
                          style: TextStyle(color: Colors.white,
                          fontSize: 20),),

                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Icon(Icons.shopping_cart,
                            color: Colors.white,
                          size: 20,),
                        )
                      ],
                    )
                  )
                ]
              ),
            )
       ] ),
      ),
    );
  }
}
