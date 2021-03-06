import 'package:flutter/material.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Routes.dart';
import 'package:complex/widget/ThemeData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es';
    return ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Complex',
        theme: themeData,
        initialRoute: '/',
        routes: Routes.routes(),
      ),
    );
  }
}
