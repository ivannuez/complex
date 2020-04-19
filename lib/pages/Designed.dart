import 'package:complex/widget/Calendar.dart';
import 'package:complex/widget/NotData.dart';
import 'package:flutter/material.dart';


class Desingned extends StatefulWidget {
  @override
  _DesingnedState createState() => _DesingnedState();
}

class _DesingnedState extends State<Desingned> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NotData()
            ],
          ),
        ),
      ),
    );
  }
}

