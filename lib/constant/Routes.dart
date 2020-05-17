import 'package:flutter/material.dart';
import 'package:complex/constant/Pages.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes() {
    return {
      '/': (context) => ScreenSplash(),
      '/base': (context) => Base(),
      '/home': (context) => Home(),
      '/transtionList': (context) => TransactionList(
            tipoForm: 'T',
            textForm: 'Transacciones',
          ),
      '/principalForm': (context) => PrincipalForm(
            tipoForm: 'E',
            textForm: 'Gasto',
            editing: false,
          ),
      '/statistics': (context) => Statistics(),
      '/settings': (context) => Settings(),
      '/settings/category': (context) => Category(),
      '/metasForm': (context) => MetasForm(
            editing: false,
            textForm: "Meta",
          ),
    };
  }
}
