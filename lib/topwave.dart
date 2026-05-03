import 'package:flutter/material.dart';


class TopWavePainter extends CustomPainter {
  final double borderRadius; // Adjust the curvature

  TopWavePainter({this.borderRadius = 40}); // Default radius

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF02270A) // Dark green color
      ..style = PaintingStyle.fill;

    var rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height), // Full width
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


