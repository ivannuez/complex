import 'package:flutter/material.dart';

class UtilsColor {
  static String convertColorValueToHex(int value) {
    final convert = Color(value)
        .toString()
        .replaceAll('Color(0xff', '')
        .replaceAll(')', '');
    return convert;
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
