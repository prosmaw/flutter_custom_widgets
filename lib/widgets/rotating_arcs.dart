import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingArcs extends StatefulWidget {
  const RotatingArcs({super.key});

  @override
  State<RotatingArcs> createState() => _RotatingArcsState();
}

class _RotatingArcsState extends State<RotatingArcs>
    with TickerProviderStateMixin {
  List<Duration> durations = [
    const Duration(seconds: 1),
    const Duration(milliseconds: 900),
    const Duration(milliseconds: 700)
  ];
  late final List<AnimationController> _animationControllers = durations
      .map((duration) => AnimationController(
            duration: duration,
            vsync: this,
          )..repeat())
      .toList();

  late final List<Animation<double>> _animations = _animationControllers
      .map((controller) =>
          Tween<double>(begin: 0, end: math.pi * 2).animate(controller))
      .toList();

  @override
  void dispose() {
    for (int i = 0; i < _animationControllers.length; i++) {
      _animationControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Rotating Arcs",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
          child: AnimatedBuilder(
              animation: _animationControllers[0],
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(80, 80),
                  painter: ArcPainter(
                    startAngles: [
                      _animations[0].value,
                      _animations[1].value,
                      _animations[2].value
                    ],
                    colors: [Colors.blue, Colors.yellow, Colors.red],
                    strokeWidth: 5,
                  ),
                );
              })),
    );
  }
}

class ArcPainter extends CustomPainter {
  double strokeWidth;
  List<Color> colors;
  List<double> startAngles;
  ArcPainter(
      {required this.startAngles,
      required this.colors,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final blueRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final yellowRect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    final redRect = Rect.fromLTWH(20, 20, size.width - 40, size.height - 40);

    final List<Paint> paints = colors
        .map((color) => Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = color)
        .toList();
    canvas.drawArc(redRect, startAngles[2], math.pi, false, paints[2]);
    canvas.drawArc(yellowRect, startAngles[1], math.pi, false, paints[1]);
    canvas.drawArc(blueRect, startAngles[0], math.pi, false, paints[0]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
