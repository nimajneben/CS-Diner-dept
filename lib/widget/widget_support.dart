import "package:flutter/material.dart";

class AppWidget{
  static TextStyle boldTextFieldStyle(){
    return const TextStyle(color: Colors.black, fontSize: 24,
        fontWeight: FontWeight.bold);
  }

  static TextStyle headLineTextFieldStyle(){
    return const TextStyle(color: Colors.black, fontSize: 22,
        fontWeight: FontWeight.bold);
  }

  static TextStyle lightTextFieldStyle(){
    return const TextStyle(color: Colors.black54, fontSize: 18,
        fontWeight: FontWeight.bold);
  }

  static TextStyle semiBoldTextFieldStyle(){
    return const TextStyle(color: Colors.black, fontSize: 20,
        fontWeight: FontWeight.bold);
  }
}