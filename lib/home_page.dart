import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )
    ..forward()
    ..repeat(reverse: false);
  late final Animation<double> _animation =
      Tween<double>(begin: 0.0, end: 4.0).animate(_animationController);

  Gradient borderGradient = const LinearGradient(colors: [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RotationTransition(
              turns: _animation,
              child: CustomPaint(
                size: const Size(280, 60),
                painter: GradientBorder(
                  gradient: borderGradient,
                  radius: const Radius.circular(20),
                  strokeWidth: 3,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GradientBorder extends CustomPainter {
  final Radius radius;
  final double strokeWidth;
  final Gradient gradient;
  final _paint = Paint()..style = PaintingStyle.stroke;

  GradientBorder(
      {required this.gradient,
      required this.radius,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, radius);
    _paint
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);
    canvas.clipRRect(rrect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
