import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

ToastMessage(status, message){
  if(status == "success"){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.white,
      textColor: Colors.greenAccent,
    );
  }else if(status == "error"){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.white,
      textColor: Colors.redAccent,
    );
  }
}
  