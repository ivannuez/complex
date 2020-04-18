import 'package:intl/intl.dart';

class UtilsFormat{
  static String formatNumber(var value){
    final formatter = new NumberFormat("#,###",'es');
    return formatter.format(value);
  }

  static int doubleToInt(var value){
    return int.parse(value.toString().replaceAll(".0", ""));
  }
}