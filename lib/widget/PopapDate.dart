import 'package:flutter/material.dart';


class PopapDate extends StatelessWidget {
  const PopapDate({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'Diciembre',
          style: Theme.of(context).textTheme.title.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).primaryTextTheme.body1.color),
        ),
      ],
    );
  }
}