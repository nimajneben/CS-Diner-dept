
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../widget/widget_support.dart';
import 'checkout_page.dart';
import 'customer_order.dart';
import "food_details.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CartDetails extends StatefulWidget {
  const CartDetails({super.key});

  @override
  State<CartDetails> createState() => _CartDetailsState();

}
bool isVip = false;  // State variable to hold VIP status


class _CartDetailsState extends State<CartDetails> {
  int aNumber = 1;
  double subtotal = 0.0;  // Subtotal of the cart items
  double oldSubtotal = 0.0;
  double totalSaved = 0.0;
  @override
  void initState() {
    super.initState();
    fetchVipStatus().then((vipStatus) {
      setState(() {
        isVip = vipStatus;  // Update the VIP status in the state
      });
    }).catchError((error) {
      // Handle errors, e.g., by showing a snackbar or logging an error
      print("Error fetching VIP status:$error");
    });
  }
  Future<bool> fetchVipStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userData['isVip']; // Assuming 'name' is the field that stores user names.
    }
    return false; // Default or error value
  }
  String userId = FirebaseAuth.instance.currentUser!.uid;  // Ensure the user is logged in
  Future<void> _updateCartAmount(int newAmount,String itemName) async {
    String cartId = itemName ;  // You need to define how you get this ID
    if (newAmount > 0){
      try {
        await FirebaseFirestore.instance
            .doc('users/$userId/Cart/$cartId')
            .update({'quantity': newAmount});
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error updating cart amount: $e'),
            backgroundColor: Colors.red));
        // Optionally handle errors, e.g., by showing a snackbar
      }
    }
    else{
      try {
        await FirebaseFirestore.instance
            .doc('users/$userId/Cart/$cartId')
            .delete();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error updating cart amount: $e'),
            backgroundColor: Colors.red));
        // Optionally handle errors, e.g., by showing a snackbar
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea( // Ensures nothing goes under system status or navigation bars
        child: SingleChildScrollView( // Allows vertical scrolling
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                // Added padding to match the original design
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manju",
                      style: AppWidget.headLineTextFieldStyle().copyWith(
                          fontSize: 45),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => const CustomerOrder())); // Assumes OrdersPage exists
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            // Text color
                            elevation: 5

                        ),
                        child: const Text('Orders'),
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(
                    userId).collection('Cart').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Text("No items in cart");
                  }

                  double newSubtotal = 0.0; // Temporary variable to calculate subtotal
                  double calculatedSubtotal = 0.0;
                  double savings = 0.0;
                  List<Widget> itemList = snapshot.data!.docs.map((
                      DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<
                        String,
                        dynamic>;
                    double price = double.parse(data['price'].toString());
                    int quantity = data['quantity'];
                    newSubtotal +=
                        price * quantity; // Add to the subtotal for each item
                    return buildCard(
                        data['itemName'], data['imageUrl'], "\$${price
                        .toStringAsFixed(2)}", quantity, data);
                  }).toList();
                  // Apply VIP discount if user is a VIP
                  if (isVip) {
                    savings = newSubtotal * 0.1;
                    calculatedSubtotal = newSubtotal;
                    newSubtotal *= 0.9; // Apply 10% discount
                  }

                  // Update the state of subtotal after building the list
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (newSubtotal != subtotal) {
                      setState(() {
                        totalSaved = savings;
                        oldSubtotal = calculatedSubtotal;
                        subtotal = newSubtotal;
                      });
                    }
                  });

                  return Column(children: itemList);
                },

              ),
              const SizedBox(height: 30.0), // Extra space at the bottom
              // Subtotal Row
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal", style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle
                            .of(context)
                            .style,
                        children: <TextSpan>[
                          // Old subtotal, struck-through
                          TextSpan(
                            text: "\$${oldSubtotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          // Space between old and new subtotal
                          const TextSpan(
                            text: " ",
                          ),
                          // New subtotal in green
                          TextSpan(
                            text: "\$${subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Center the button
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (totalSaved > 0) // Assuming you have a variable for this
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Total saved as VIP: \$${totalSaved
                    .toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CheckoutPage(subtotal: subtotal, vip:isVip )));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text and icon color
                minimumSize: Size(MediaQuery
                    .of(context)
                    .size
                    .width, 50), // Button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      0), // Flat rectangular button
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 10),
                  Text('Go to checkout', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildCard(String title, String imagePath, String price, int amount,Map<String, dynamic> ds ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  FoodDetails(itemName: ds['itemName'], // Assuming 'itemName' is the field name in your document
            imageUrl: ds['imageUrl'],
            description: ds['description'],
            chef: ds['chef'],
            allergens: ds['allergens'],
            chefId: ds['chefId'],
            price: ds['price'],
            rating: ds['rating']))); //should be changed to order details function eventually
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: imagePath,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          title,
                          style: AppWidget.semiBoldTextFieldStyle(),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          price,
                          style: AppWidget.semiBoldTextFieldStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
                AmountControl(amount: amount, onUpdate: (newAmount) {
                  setState(() {
                    amount = newAmount;
                  });
                  _updateCartAmount(newAmount, title);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class AmountControl extends StatefulWidget {
  final int amount;
  final Function(int) onUpdate;

  const AmountControl({super.key, required this.amount, required this.onUpdate});

  @override
  _AmountControlState createState() => _AmountControlState();
}

class _AmountControlState extends State<AmountControl> {
  late int currentAmount;

  @override
  void initState() {
    super.initState();
    currentAmount = widget.amount;
  }

  void _increment() async {
    setState(() {
      currentAmount++;
    });
    widget.onUpdate(currentAmount);
  }

  void _decrement() {
    if (currentAmount > 0) {
      setState(() {
        currentAmount--;
      });
      widget.onUpdate(currentAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,  // Adjust size as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _decrement,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.red,  // Example color
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          Text('$currentAmount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: _increment,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.green,  // Example color
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}