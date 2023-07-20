import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void getToast({required String toastName}){
  Fluttertoast.showToast(
    msg: toastName,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}