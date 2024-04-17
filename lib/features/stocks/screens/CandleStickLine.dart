import 'package:flutter/material.dart';

import '../../../utils/Colors.dart';

class CandlestickChart extends StatelessWidget {
  final double low;
  final double high;
  final double open;
  final double close;

  const CandlestickChart({
    Key? key,
    required this.low,
    required this.high,
    required this.open,
    required this.close,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double minValue = low;
    final double maxValue = high;
    final double openValue = open;
    final double closeValue = close;

    return Container(
      width: double.infinity,
      height: 20,
      child: CustomPaint(
        painter: CandlestickPainter(
          minValue: minValue,
          maxValue: maxValue,
          openValue: openValue,
          closeValue: closeValue,
        ),
      ),
    );
  }
}

class CandlestickPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double openValue;
  final double closeValue;

  CandlestickPainter({
    required this.minValue,
    required this.maxValue,
    required this.openValue,
    required this.closeValue,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final Paint linePaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 8;

    final Paint rectPaint = Paint()
      ..color = AppColors.midBlue
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    // Calculate positions
    final double lowX = 0.0;
    final double highX = width;
    final double openX = (openValue - minValue) / (maxValue - minValue) * width;
    final double closeX = (closeValue - minValue) / (maxValue - minValue) * width;

    // Draw line
    canvas.drawLine(Offset(lowX, height / 2), Offset(highX, height / 2), linePaint);

    // Draw rectangle
    canvas.drawRect(
      Rect.fromLTRB(openX, height / 4, closeX, height * 3 / 4),
      rectPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
