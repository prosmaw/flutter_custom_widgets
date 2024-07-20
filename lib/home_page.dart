import 'package:custom_widgets/widgets/angular_gradient_button.dart';
import 'package:custom_widgets/widgets/gradient_border.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 15),
    vsync: this,
  )..repeat();

  late final Animation<double> _turnAnimation =
      Tween<double>(begin: 0.0, end: 4.0).animate(_animationController);
  Gradient get borderGradient => const LinearGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.purple,
          Colors.pink
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Custom widgets",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: AngularGradientButton(),
          ),
          const SizedBox(
            height: 30,
          ),
          Stack(
            children: [
              GradientBorder(
                  gradient: borderGradient,
                  radius: 180,
                  size: const Size(150, 150),
                  strokeWidth: 25),
              RotationTransition(
                turns: _turnAnimation,
                child: CustomPaint(
                  size: const Size(150, 150),
                  painter: CustomArc(
                    color: const Color.fromARGB(255, 58, 56, 56),
                    strokeWidth: 25,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomArc extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final _paint = Paint()..style = PaintingStyle.stroke;

  CustomArc({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    _paint
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    canvas.drawArc(rect, -math.pi / 2, -math.pi * 7 / 4, false, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
