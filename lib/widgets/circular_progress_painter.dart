import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressPainter extends CustomPainter {
  final BuildContext context;

  CircularProgressPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 9;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const double startAngle = -pi / 2; // Start from top

    Paint paintSegment(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // 'butt' ensures spacing works

    // Background Arc (Grey)
    Paint backgroundPaint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Define values
    double totalAngle = 2 * pi; // Full circle
    double gapSize = 0.3; // Small gap in radians (~4 degrees)

    double firstSegment = (45 / 100) * totalAngle - gapSize;
    double secondSegment = (35 / 100) * totalAngle - gapSize;
    double thirdSegment = (20 / 100) * totalAngle - gapSize;

    // Draw Grey Background Arc
    canvas.drawArc(rect, 0, totalAngle, false, backgroundPaint);

    // Draw First Segment (45% - Red)
    canvas.drawArc(
        rect, startAngle, firstSegment, false, paintSegment(Colors.red));

    // Draw Second Segment (35% - Green)
    canvas.drawArc(rect, startAngle + firstSegment + gapSize, secondSegment,
        false, paintSegment(Colors.amber));

    // Draw Third Segment (20% - Blue)
    canvas.drawArc(
        rect,
        startAngle + firstSegment + secondSegment + 2 * gapSize,
        thirdSegment,
        false,
        paintSegment(Colors.blue));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
