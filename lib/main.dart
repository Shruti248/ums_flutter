import 'package:flutter/material.dart';
// import 'package:ums_flutter/register.dart';
import 'login.dart';
// import 'UMSHomePage.dart';
import 'package:get/get.dart';

void main(){

  runApp(
      GetMaterialApp(
      // home : MyForm()
      home: MyLoginForm(),
      // home: UMSHomePage(),
    )
  );
}


