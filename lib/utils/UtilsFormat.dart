import 'package:intl/intl.dart';

class UtilsFormat{
  static String formatNumber(var value){
    final formatter = new NumberFormat("#,###",'es');
    return formatter.format(value);
  }
}