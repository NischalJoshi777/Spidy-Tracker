import 'dart:math';
import 'package:flutter/material.dart';

class WebCornerPainter extends CustomPainter {
  final Color color;
  final int strands;
  final int rings;

  WebCornerPainter({
    this.color = Colors.white,
    this.strands = 8,
    this.rings = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final origin = Offset(size.width, 0);
    final maxRadius = size.longestSide;
    final startAngle = pi / 2;
    final endAngle = pi;

    // Radial strands
    for (int i = 0; i <= strands; i++) {
      final angle = startAngle + (endAngle - startAngle) * (i / strands);
      final end = origin + Offset(cos(angle), sin(angle)) * maxRadius;
      canvas.drawLine(origin, end, paint);
    }

    // Concentric arcs connecting the strands
    for (int r = 1; r <= rings; r++) {
      final radius = maxRadius * r / rings;
      final path = Path();
      for (int i = 0; i <= strands; i++) {
        final angle = startAngle + (endAngle - startAngle) * (i / strands);
        final point = origin + Offset(cos(angle), sin(angle)) * radius;
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WebCornerBackground extends StatelessWidget {
  final Widget child;
  final Color color;
  const WebCornerBackground({
    super.key,
    required this.child,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: WebCornerPainter(color: color)),
        ),
        child,
      ],
    );
  }
}
