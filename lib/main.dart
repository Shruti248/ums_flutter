import 'package:flutter/material.dart';
// import 'package:ums_flutter/register.dart';
import 'login.dart';
// import 'UMSHomePage.dart';
import 'package:dio/dio.dart';

void main(){

  runApp(
    const MaterialApp(
      // home : MyForm()
      home: MyLoginForm(),
      // home: UMSHomePage(),
    )
  );
}


