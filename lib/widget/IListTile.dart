import 'package:flutter/material.dart';

class IListTile extends StatelessWidget {

  final Color color;
  final String descripcion;

  const IListTile({
    Key key,
    this.color,
    this.descripcion
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor:color,
          child: Text(
            descripcion[0],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          descripcion,
        ),
      ],
    );
  }
}