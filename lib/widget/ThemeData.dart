import 'package:flutter/material.dart';

var themeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.blue,
  backgroundColor: Colors.grey,
  textTheme: TextTheme(
    headline6: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black),
    subtitle1: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
    subtitle2: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
    caption: TextStyle(
        fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.black),
    //body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);
