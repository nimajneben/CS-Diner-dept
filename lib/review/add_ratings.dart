import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:manju_three/widget/widget_support.dart';

class AddRatings extends StatefulWidget {
  String itemId, itemName, chefName, chefId;
  double rating;
   AddRatings({super.key,
    required this.itemId,
    required this.itemName,
    required this.chefName,
    required this.chefId,
    required this.rating});

  @override
  State<AddRatings> createState() => _AddRatingsState();
}

class _AddRatingsState extends State<AddRatings> {

  TextEditingController _reviewController = TextEditingController();
  late final _ratingController = TextEditingController();
  late double _userRating = 3.0;

   addItemRating() async{

    if (_ratingController == null || _reviewController == null) {
  // Handle error, inform user to input correct format
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Please enter a Rating or Review"),
    backgroundColor: Colors.red,
  ));
  return; // Exit function if price is not valid
}

Map<String, dynamic> ratingData = {
  'itemid': widget.itemId,
  'itemName': widget.itemName,
  'chefName': widget.chefName,
  'chefId': widget.chefId,
  'rating': double.parse(_ratingController.text.trim()),
  'review': _reviewController.text,


};
      


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text("Add Ratings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:  Column(
        children: [
          Container(
          padding: EdgeInsets.only(top: 40,),
          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          // Icon(Icons.star, color: Colors.yellow[900], size: 80),
                          Text(widget.rating.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                RatingBar.builder(
                itemSize: 20,
               initialRating: widget.rating,
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
                 
               },
            )
                        ],
                      ),
                      Column(
                        children: [
                          Text(widget.itemName, style: AppWidget.headLineTextFieldStyle()),
                          Text(widget.chefName, style: AppWidget.semiBoldTextFieldStyle()),
                        ],
                      ),
                    ],
                  ),
        ),

        SizedBox(height: 50,),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              
                  RatingBarIndicator(
                    rating: _userRating,
                    itemBuilder: (context, index) => Icon(
                       Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter rating',
                        labelText: 'Enter rating',
                        suffixIcon: MaterialButton(
                          onPressed: () {
                            _userRating =
                                double.parse(_ratingController.text ?? '0.0');
                            setState(() {});
                          },
                          child: Text('Rate'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
              
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                maxLines: 10,
                controller: _reviewController,
                decoration: InputDecoration(
                  hintText: "Add a review",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                            ),
              ),

            SizedBox(height: 20,),

            GestureDetector(
              onTap: (){},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF008080)
                ),
                child: Center(
                  child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            )
            
        ]),
        
        )
      ]),
      
      
      
      );


  }
}