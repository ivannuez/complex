import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgress extends CustomPainter {
  final int porcentaje;
  final Color colorBase;
  final double widthBase;
  final Color colorArc;
  final double widthArc;

  CircularProgress(
      {this.porcentaje,
      this.colorBase,
      this.colorArc,
      this.widthArc,
      this.widthBase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorBase
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = widthBase;

    final paintArc = Paint()
      ..color = colorArc
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = widthArc;

    //Esto es para dibujar un circulo
    Offset center = new Offset(size.width * 0.5, size.height / 2);
    double radio = min(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(center, radio, paint);

    //Ahora vamos a dibujar un Circular progress
    double arcAngle = 2 * pi * (porcentaje / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radio), (-pi / 2),
        arcAngle, false, paintArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
