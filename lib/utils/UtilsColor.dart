import 'package:flutter/material.dart';

class UtilsColor{
  static String convertColorValueToHex(int value){
    final convert = Color(value).toString().replaceAll('Color(0xff', '').replaceAll(')', '');
    return convert;
  }
}