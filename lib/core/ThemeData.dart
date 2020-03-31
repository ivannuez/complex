import 'package:flutter/material.dart';

var themeData = ThemeData(
  // Define el Brightness y Colores por defecto
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.blue,
  backgroundColor: Colors.white,

  // Define la Familia de fuente por defecto
  //fontFamily: 'Montserrat',

  // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
  // para cabeceras, títulos, cuerpos de texto, y más.
  textTheme: TextTheme(
    //headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal , color: Colors.white),
    //body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);
