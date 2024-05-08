
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manju_restaurant/pages/bottomnav.dart';

import '../widget/widget_support.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

String name = "", email ="", password = "";

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

//global key for the form
  final _formKey = GlobalKey<FormState>();

registration() async {
  if (password != null){
    try{
      UserCredential userCredential = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );

      addDetails(nameController.text.trim(), emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Registration Successful",
        style: TextStyle(fontSize: 20)),
      ));

      //using pushReplacement to remove the back button, the user can't go back to the signup page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNav()));
    } on FirebaseException catch (e){
      if (e.code == 'weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("The password provided is too weak",
          style: TextStyle(fontSize: 20)),
        ));
      } else if (e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("The account already exists for that email",
          style: TextStyle(fontSize: 20)),
        ));
      }
    } catch (e){
      print(e);
    }
  }
}

Future addDetails(String name, String email) async{
    await FirebaseFirestore.instance.collection('users').add(
      {
        'name': name,
        'email': email,
        'isApproved':false,
        'isSuspended':false,
        'warning': 0,
        'deposit': 50.0,
        'totalOrders': 0,
        'totalSpent': 0.0,
        'isVip': false,


      }
    );
    
}




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:SingleChildScrollView(
          child: Container(
            child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/1.2,
                    width: MediaQuery.of(context).size.width,
                    /*LinearGradient is a class that creates a gradient effect,
                we can use it to create a gradient effect for the container,
                can take multiple colors, begin and end properties are used to
                define the direction of the gradient effect
                 */
                    decoration: BoxDecoration(gradient: LinearGradient(
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
                    margin:EdgeInsets.only(top:MediaQuery.of(context).size.height/3),
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )
                    ),
                  ),
          
                  //need a logo or something nice for the login page
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 30, right: 30),
                    child: Column(
          
                      children:
                      [
          
                        Center(
                          child: Text("MANJU ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
          
          
                        /*if we want to add a logo, we can use the Image.asset() widget
                    plus we need to adjust the size of the image and the space
                    between the image and the text
          
                 */
                        SizedBox(height: 50,),
                        SingleChildScrollView(
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/1.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:
                              Form(
                                key:_formKey,
                                child: Column(
                                  children:
                                  [
                                    SizedBox(height: 30,),
                                    Text("Register",
                                      style: AppWidget.headLineTextFieldStyle(),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 30,),
                                    TextFormField(
                                      controller: nameController,
                                      validator: (value){
                                        if (value!.isEmpty){
                                          return "Please enter your name";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Name",
                                        hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.person),
                          
                                      ),
                                    ),
                                    SizedBox(height: 30,),
                                    TextFormField(
                                      controller: emailController,
                                      validator: (value){
                                        if (value!.isEmpty){
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
                          
                                    SizedBox(height: 30,),
                                    TextFormField(
                                      controller: passwordController,
                                      validator: (value){
                                        if (value!.isEmpty){
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
                                    SizedBox(height: 30,),
                          
                          
                                    SizedBox(height: 50,),
                                    GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()){
                                          setState(() {
                                            name = nameController.text;
                                            email = emailController.text;
                                            password = passwordController.text;
                                          });
                                          
                                        }
                                        registration();
                                      },
                                      child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          width: 200,
                                          decoration:  BoxDecoration(gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Colors.blue, Colors.green],
                                      
                                          ),
                                              borderRadius: BorderRadius.circular(30)),
                                          child: const Center(
                                            child: Text("Next",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
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
                        ),
                        SizedBox(height: 50,),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                LogIn()));
                          },
                          child: Text("Already have an account? Log In",
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            ),
          ),
        )
    );
  }
}
