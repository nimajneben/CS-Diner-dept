// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:manju_three/Manager/manager_bottomnav.dart';
import 'package:manju_three/Manager/manager_home.dart';
import 'package:manju_three/admin/admin_nav.dart';
import 'package:manju_three/chef/chef_bottomnav.dart';
import 'package:manju_three/methods/data.dart';
import 'package:manju_three/pages/user_unapproved_page.dart';
import 'package:manju_three/pages/bottomnav.dart';
import 'package:manju_three/pages/user_registration.dart';
import 'package:manju_three/pages/surfer_home.dart';
import 'package:manju_three/Importer/importer_menu.dart';
import 'package:manju_three/delivery/delivery_menu.dart';

import '../widget/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "";
  String password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Future<String> role = DatabaseFunctions()
          .getUserRole(FirebaseAuth.instance.currentUser!.uid);
      role.then((value) {
        if (value == "chef") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ChefNav()),
              (route) => false);
        } else if (value == "admin") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ManagerNav()),
              (route) => false);
        } else if (value == "importer") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: ((context) => ImporterMainScreen())),
              (route) => false);
        } else if (value == "delivery") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: ((context) => DeliveryMainScreen())),
              (route) => false);
        } else {
          Future<bool> isApproved = DatabaseFunctions()
              .getApprovalInfo(FirebaseAuth.instance.currentUser!.uid);
          if (isApproved == false) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ApprovalPage()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BottomNav()));
          }
        }
      });

      // Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // Check here as well before showing the SnackBar
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = 'Wrong email or password provided.';
          break;
        case 'user-disabled':
          errorMessage =
              'The user account has been disabled by an administrator.';
          break;
        case 'invalid-email': // Ensure this case matches exactly with FirebaseAuth's error codes
          errorMessage = 'The email address is badly formatted.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height / 2.5,
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
                  colors: const [Colors.blue, Colors.green])),
        ),
        Container(
          /*
              * MediaQuary is responsible for getting the size of the screen
              * and then we can use it to set the margin of the container
              * it also helps in making the app responsive.
              *
              * */
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
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
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Login",
                          style: AppWidget.headLineTextFieldStyle(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty || value == '') {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: AppWidget.semiBoldTextFieldStyle(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty || value == '') {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: AppWidget.semiBoldTextFieldStyle(),
                            prefixIcon: Icon(Icons.password),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Forgot Password?",
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              email = emailController.text;
                              password = passwordController.text;
                            }
                            userLogin();
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
                                    colors: const [Colors.blue, Colors.green],
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Center(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
              ),
            ],
          ),
        )
      ]),
    ));
  }
}
