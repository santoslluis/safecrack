import 'dart:math' as math;
import 'package:flutter/material.dart';

class DialWidget extends StatelessWidget {
  final double rotation;
  final double size;
  final Color primaryColor;
  final Color accentColor;
  final bool isActive;
  final int? feedbackState;

  const DialWidget({
    super.key,
    required this.rotation,
    this.size = 200,
    this.primaryColor = Colors.grey,
    this.accentColor = Colors.deepPurple,
    this.isActive = true,
    this.feedbackState,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DialPainter(
          rotation: rotation,
          primaryColor: primaryColor,
          accentColor: accentColor,
          isActive: isActive,
          feedbackState: feedbackState,
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  final double rotation;
  final Color primaryColor;
  final Color accentColor;
  final bool isActive;
  final int? feedbackState;

  _DialPainter({
    required this.rotation,
    required this.primaryColor,
    required this.accentColor,
    required this.isActive,
    this.feedbackState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final bgPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    final borderPaint = Paint()
      ..color = isActive ? accentColor : primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);

    final tickPaint = Paint()
      ..color = primaryColor.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * math.pi / 180;
      final isMajor = i % 5 == 0;
      final innerRadius = radius - (isMajor ? 20 : 10);
      final outerRadius = radius - 5;

      final start = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );

      tickPaint.strokeWidth = isMajor ? 3 : 1.5;
      canvas.drawLine(start, end, tickPaint);
    }

    final indicatorAngle = rotation * math.pi / 180 - math.pi / 2;
    final indicatorLength = radius * 0.7;

    Color indicatorColor = accentColor;
    if (feedbackState == 1) {
      indicatorColor = Colors.green;
    } else if (feedbackState == -1) {
      indicatorColor = Colors.red;
    }

    final indicatorPaint = Paint()
      ..color = indicatorColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final indicatorEnd = Offset(
      center.dx + indicatorLength * math.cos(indicatorAngle),
      center.dy + indicatorLength * math.sin(indicatorAngle),
    );
    canvas.drawLine(center, indicatorEnd, indicatorPaint);

    final centerPaint = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, centerPaint);

    final innerCenterPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, innerCenterPaint);
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) {
    return rotation != oldDelegate.rotation ||
        isActive != oldDelegate.isActive ||
        feedbackState != oldDelegate.feedbackState;
  }
}
