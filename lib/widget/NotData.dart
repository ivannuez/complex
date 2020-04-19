import 'package:flutter/material.dart';

class NotData extends StatelessWidget {
  const NotData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/icono-triste.png',
            height: 50,
            width: 60,
          ),
          SizedBox(height: 10,),
          Text("!Sin datos!", style: TextStyle(fontSize: 17),),
        ],
      ),
    );
  }
}
