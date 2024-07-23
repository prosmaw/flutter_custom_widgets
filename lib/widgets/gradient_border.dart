import 'package:flutter/material.dart';

class GradientBorder extends StatefulWidget {
  const GradientBorder(
      {super.key,
      required this.gradient,
      required this.radius,
      required this.size,
      required this.strokeWidth});
  final Gradient gradient;
  final double radius, strokeWidth;
  final Size size;
  @override
  State<GradientBorder> createState() => _HomePageState();
}

class _HomePageState extends State<GradientBorder> {
  @override
  void dispose() {
    //_animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: BorderPainter(
        gradient: widget.gradient,
        radius: Radius.circular(widget.radius),
        strokeWidth: widget.strokeWidth,
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final Radius radius;
  final double strokeWidth;
  final Gradient gradient;
  final _paint = Paint()..style = PaintingStyle.stroke;

  BorderPainter(
      {required this.gradient,
      required this.radius,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    //main bound
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    //rounded rectangle definition
    final rrect = RRect.fromRectAndRadius(rect, radius);

    // paint definition with the gadient
    _paint
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);

    // draw the rounded rectangle with the paint
    canvas.drawRRect(rrect, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
