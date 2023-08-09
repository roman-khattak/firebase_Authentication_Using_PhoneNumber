import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//This function toastMessage(){Fluttertoast.showToast} is used to give a short message pop-up to user about the error

// ......................I haven't used it in code yet because troublesome.......................................

class Utilities{
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,   // show for less time
        gravity: ToastGravity.CENTER,      //where to show message
        timeInSecForIosWeb: 5,            // time length for message display
        backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}