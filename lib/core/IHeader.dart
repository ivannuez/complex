import 'package:flutter/material.dart';
import 'package:complex/core/ICircularBottom.dart';

class IHeader extends StatelessWidget {
  final String text;
  final Color color;
  const IHeader({Key key,this.text,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          ICircularBottom(height: 15,radius: 20,)
        ],
      ),
    );
  }
}