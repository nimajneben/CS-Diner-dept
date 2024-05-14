import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manju_three/widget/widget_support.dart';

class UserRatings extends StatefulWidget {
  final String itemName;
  const UserRatings({super.key, required this.itemName});

  @override
  State<UserRatings> createState() => _UserRatingsState();
}

class _UserRatingsState extends State<UserRatings> {
  Stream<QuerySnapshot> fetchReviews() {
    return FirebaseFirestore.instance
        .collection('Reviews')
        .where('itemName', isEqualTo: widget.itemName)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for ${widget.itemName}', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reviews found for this item.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot reviewDoc = snapshot.data!.docs[index];
              Map<String, dynamic> reviewData = reviewDoc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10.0),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 5),
                          Text(reviewData['rating'].toString(), style: AppWidget.semiBoldTextFieldStyle()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        reviewData['review'],
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Reviewed on: ${DateFormat('yyyy-MM-dd').format((reviewData['timestamp'] as Timestamp).toDate())}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
