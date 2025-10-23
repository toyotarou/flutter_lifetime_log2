import 'package:flutter/material.dart';

///
class DiagonalSlashPainter extends CustomPainter {
  ///
  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), p);
  }

  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
