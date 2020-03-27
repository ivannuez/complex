import 'package:flutter/material.dart';

class ICircularBottom extends StatelessWidget {
  final double height;
  final double radius;
  const ICircularBottom({Key key, this.height, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0, color: Colors.white),
        ),
      ),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
      ),
    );
  }
}
