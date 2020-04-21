import 'package:flutter/material.dart';

class NotData extends StatelessWidget {
  final Widget child;

  NotData({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      child: Column(
        mainAxisAlignment:
            (child == null ? MainAxisAlignment.center : MainAxisAlignment.end),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/icono-triste.png',
            height: 50,
            width: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "!Sin datos!",
            style: TextStyle(fontSize: 17),
          ),
          (child == null
              ? Container()
              : Container(
                  child: child,
                  margin: EdgeInsets.only(bottom: 15),
                ))
        ],
      ),
    );
  }
}
