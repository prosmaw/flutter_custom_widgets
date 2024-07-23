import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:custom_widgets/style.dart';

class RotatingGradientArc extends StatefulWidget {
  const RotatingGradientArc({super.key});

  @override
  State<RotatingGradientArc> createState() => _RotatingGradientArcState();
}

class _RotatingGradientArcState extends State<RotatingGradientArc>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat();

  late final Animation<double> _turnAnimation =
      Tween<double>(begin: 0, end: math.pi * 2).animate(_animationController);
  Gradient get borderGradient => const LinearGradient(colors: BaseColors.grad1);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Rotating gradient arc",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(200, 200),
                painter: GradientArcPainter(
                    startAngle: _turnAnimation.value, gradient: borderGradient),
              );
            }),
      ),
    );
  }
}

class GradientArcPainter extends CustomPainter {
  double startAngle;
  Gradient gradient;
  GradientArcPainter({required this.startAngle, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 20.0;
    final double radius = (size.width / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Grey circle paint definition and drawing
    final Paint circlePaint = Paint()
      ..color = const Color.fromARGB(255, 81, 78, 78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, circlePaint);

    // gradient paint
    final Paint gradientPaint = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // arc path
    final Path arcPath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        3.14 / 4,
      );

    //draw path with the gradient paint
    canvas.drawPath(arcPath, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
