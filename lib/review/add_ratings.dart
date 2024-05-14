import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRatings extends StatefulWidget {
  final List<dynamic> items;  // Accepting List<dynamic>
  final Map<String, dynamic> checkoutMethod;
  final bool deliverer;

  AddRatings({
    Key? key,
    required this.items,
    required this.checkoutMethod, required this.deliverer,
  }) : super(key: key);

  @override
  State<AddRatings> createState() => _AddRatingsState();
}

class _AddRatingsState extends State<AddRatings> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _complaintDescriptionController = TextEditingController();
  String feedbackType = 'compliment';
  String? selectedChefId;
  String? selectedChefName;
  String? selectedItemId;
  String? selectedItemName;

  // Extract unique chefs from the items list
  List<Map<String, String>> getUniqueChefs() {
    Map<String, String> chefs = {};
    for (var item in widget.items) {
      if (item is Map<String, dynamic> && item.containsKey('chefId') && item.containsKey('chef')) {
        chefs[item['chefId']] = item['chef'];
      }
    }
    return chefs.entries.map((e) => {'chefId': e.key, 'chefName': e.value}).toList();
  }



  Future<void> addItemRating(String itemName, double rating, String review) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    Map<String, dynamic> ratingData = {
      'itemName': itemName,
      'rating': rating,
      'review': review,
      'timestamp': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('Reviews').add(ratingData);

    // Update the item rating in the menu collection
    DocumentReference itemRef = FirebaseFirestore.instance.collection('Menu').doc(itemName);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(itemRef);
      if (!snapshot.exists) {
        throw Exception("Item does not exist!");
      }
      double currentRating = snapshot.get('rating').toDouble();
      int numberOfReviews = snapshot.get('numberOfReviews').toInt();

      double newRating = (currentRating * numberOfReviews + rating) / (numberOfReviews + 1);
      int newRatingCount = numberOfReviews + 1;

      transaction.update(itemRef, {'rating': newRating, 'numberOfReviews': newRatingCount});
    });
  }

  Future<void> addComplimentOrComplaint() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String collectionName = feedbackType == 'compliment' ? 'Compliment' : 'Complaint';
    String? personId = selectedChefId;
    String? personName = selectedChefName;
    if(widget.deliverer){
      personId = widget.checkoutMethod['deliveryperson'];
      personName = 'Delivery Person';
    }

    Map<String, dynamic> data = {
      'filersId': user.uid,
      'timestamp': Timestamp.now(),
      'comment': _reviewController.text,
      'category': feedbackType,
    };

    if (feedbackType == 'compliment') {
      data.addAll({
        'personId': personId,
        'personName': personName,
      });
    } else {
      data.addAll({
        'description': _complaintDescriptionController.text,
        'personAccusedId': personId,
        'appealed': false,
        'appealedVerdict': 'unknown',
        'mgr_reviewed': false,
        'mgr_verdict': 'innocent',
      });
    }

    await FirebaseFirestore.instance.collection(collectionName).add(data);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> uniqueChefs = getUniqueChefs();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("Add Ratings"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Rate Your Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: feedbackType,
              items: const [
                DropdownMenuItem(value: 'compliment', child: Text('Compliment')),
                DropdownMenuItem(value: 'complaint', child: Text('Complaint')),
              ],
              onChanged: (value) {
                setState(() {
                  feedbackType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            if (!widget.deliverer)
              DropdownButton<String>(
                hint: const Text('Select a Chef'),
                value: selectedChefId,
                items: uniqueChefs.map((chef) {
                  return DropdownMenuItem<String>(
                    value: chef['chefId'],
                    child: Text(chef['chefName']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChefId = value;
                    selectedChefName = uniqueChefs.firstWhere((chef) => chef['chefId'] == value)['chefName'];
                  });
                },
              ),
            if (feedbackType == 'complaint')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _complaintDescriptionController,
                  decoration: const InputDecoration(
                    hintText: "Complaint Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (!widget.deliverer)
            ...widget.items.whereType<Map<String, dynamic>>().map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['itemName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          item['userRating'] = rating;
                        });
                      },
                    ),
                    TextField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        hintText: "Add a review",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (!widget.deliverer) {
                  for (var item in widget.items.whereType<
                      Map<String, dynamic>>()) {
                    await addItemRating(
                      item['itemName'],
                      item['userRating'],
                      _reviewController.text,
                    );
                  }
                }
                await addComplimentOrComplaint();
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF008080),
                ),
                child: const Center(
                  child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
