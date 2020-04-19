import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {

  final Color color;

  CurvePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    paint.color = color;
    paint.style = PaintingStyle.fill; // stroke
    paint.strokeWidth = 5;

    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.50, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.60, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}