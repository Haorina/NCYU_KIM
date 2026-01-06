import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path_drawing/path_drawing.dart';

class RadarChartPainter extends CustomPainter {
  RadarChartPainter({
    required this.currentScore,
    required this.maxScore,
    required this.screenWidth,
    required this.screenHeight,
    required this.labels,
  });

  final double screenWidth;
  final double screenHeight;
  final List<double> currentScore;
  final List<double> maxScore;
  final List<String> labels;

  void _drawDiagonals(
      Canvas canvas,
      double centerX,
      double centerY,
      double radius,
      Paint paint,
      ) {
    for (int i = 0; i < currentScore.length; i++) {
      final angle = (i * pi * 2 / currentScore.length) - pi / 2;
      final dx = centerX + radius * cos(angle);
      final dy = centerY + radius * sin(angle);
      canvas.drawLine(Offset(centerX, centerY), Offset(dx, dy), paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(screenWidth * 0.608 / 2, screenHeight * 0.28 / 2);
    final radius = screenWidth * 0.6 / 2;

    final paint =
    Paint()
      ..color = const Color(0x8066DFEA)
      ..style = PaintingStyle.fill;

    final borderPaint =
    Paint()
      ..color = const Color(0xFF66DFEA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    for (int i = 0; i < currentScore.length; i++) {
      final angle = (2 * pi / currentScore.length) * i - pi / 2;
      final value = currentScore[i];
      final normalizedValue = max(0, (value / maxScore[i]) * radius);
      final x = center.dx + normalizedValue * cos(angle);
      final y = center.dy + normalizedValue * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final gridPaint =
    Paint()
      ..color = const Color(0XFFCFCFCF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 1; i <= 5; i++) {
      final gridRadius = (i / 5) * radius;
      final gridPath = Path();
      for (int j = 0; j < currentScore.length; j++) {
        final angle = (2 * pi / currentScore.length) * j - pi / 2;
        final x = center.dx + gridRadius * cos(angle);
        final y = center.dy + gridRadius * sin(angle);
        if (j == 0) {
          gridPath.moveTo(x, y);
        } else {
          gridPath.lineTo(x, y);
        }
      }
      gridPath.close();

      final dashedGridPath = dashPath(
        gridPath,
        dashArray: CircularIntervalList<double>([5, 3]),
      );
      canvas.drawPath(dashedGridPath, gridPaint);
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    final diagonalPaint =
    Paint()
      ..color = const Color(0XFF9F9F9F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _drawDiagonals(canvas, center.dx, center.dy, radius, diagonalPaint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (int i = 0; i < labels.length; i++) {
      if(labels.length == 4) {
        final angle = (2 * pi / labels.length) * i - pi / 2;
        final x = center.dx + (radius + 38) * cos(angle);
        final y = center.dy + (radius + 30) * sin(angle);

        textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(color: Colors.black87, fontSize: screenWidth * 0.034),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2),
        );
      }
      else {
        final angle = (2 * pi / labels.length) * i - pi / 2;
        final x = center.dx + (radius + 45) * cos(angle);
        final y = center.dy + (radius + 45) * sin(angle);

        textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(color: Colors.black87, fontSize: screenWidth * 0.034),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
