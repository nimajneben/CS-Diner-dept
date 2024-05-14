// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:manju_three/pages/login.dart';
import 'package:manju_three/pages/user_unapproved_page.dart';

import '../widget/widget_support.dart';
// import 'approval_page.dart';

class SecondPage extends StatefulWidget {
  final String? email, name, password;

  SecondPage(
      {super.key,
      required this.email,
      required this.name,
      required this.password});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int deposit = 0;
  String address = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  registration() async {
    // Ensure the password is not null and the form is validated before proceeding
    if (widget.password != null && _formKey.currentState!.validate()) {
      // Directly using values from controllers
      String address = addressController.text;
      int deposit = int.tryParse(depositController.text) ?? 0;

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email!,
          password: widget.password!,
        );

        await addDetails(userCredential.user!.uid, widget.name!, widget.email!,
            address, deposit);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content:
              Text("Registration Successful", style: TextStyle(fontSize: 20)),
        ));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ApprovalPage()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("The password provided is too weak",
                style: TextStyle(fontSize: 20)),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("The account already exists for that email",
                style: TextStyle(fontSize: 20)),
          ));
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addDetails(String uId, String name, String email, String address,
      int deposit) async {
    await FirebaseFirestore.instance.collection('users').doc(uId).set({
      'name': name,
      'email': email,
      'role': 'customer',
      'isApproved': false,
      'isSuspended': false,
      'warning': 0,
      'wallet': deposit,
      'address': address,
      'totalOrders': 0,
      'totalSpent': 0.0,
      'isVip': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            /*LinearGradient is a class that creates a gradient effect,
                we can use it to create a gradient effect for the container,
                can take multiple colors, begin and end properties are used to
                define the direction of the gradient effect
                 */
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.green])),
          ),
          Container(
            /*
                * MediaQuary is responsible for getting the size of the screen
                * and then we can use it to set the margin of the container
                * it also helps in making the app responsive.
                *
                * */
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
          ),
          Positioned(
            top: 40, // Adjust the position based on your design needs
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.white), // Change color if needed
              onPressed: () => Navigator.pop(context),
            ),
          ),

          //need a logo or something nice for the login page
          Container(
            margin: EdgeInsets.only(top: 50, left: 30, right: 30),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "MANJU ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                /*if we want to add a logo, we can use the Image.asset() widget
                    plus we need to adjust the size of the image and the space
                    between the image and the text
          
                 */
                SizedBox(
                  height: 50,
                ),
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Register",
                            style: AppWidget.headLineTextFieldStyle(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: addressController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your Address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Address",
                              hintStyle: AppWidget.semiBoldTextFieldStyle(),
                              prefixIcon: Icon(Icons.book_online),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: depositController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your deposit';
                              }
                              final n = int.tryParse(value);
                              if (n == null) {
                                return 'Please enter a valid number';
                              }
                              if (n < 0 || n > 150) {
                                // Assuming you want to limit the deposit amount
                                return 'Please enter a Deposit greater than 0 \n and less than 100';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Desposit Amount",
                              hintStyle: AppWidget.semiBoldTextFieldStyle(),
                              prefixIcon: Icon(Icons.money_rounded),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  address = addressController.text;
                                  deposit = int.parse(depositController.text);
                                });
                              }
                            },
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: 200,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.blue, Colors.green],
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                child: GestureDetector(
                                  onTap: () {
                                    registration();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogIn()));
                  },
                  child: Text(
                    "Already have an account? Log In",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    ));
  }
}
