import 'dart:ui' as ui; //to avoid conflict

import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  //definition of the text with textPainter in order to get its width
  final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
          text: "Loading...",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34)))
    ..layout(maxWidth: 200);

  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat(reverse: true);

  late final Animation<double> animation =
      Tween<double>(begin: 20, end: textPainter.width - 20)
          .animate(_animationController);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 85, 84, 84),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Loading Animation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 85, 84, 84),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(textPainter.width, textPainter.width),
                painter: LoadingPainter(circleOffsetdx: animation.value),
              );
            }),
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  final double circleOffsetdx;
  LoadingPainter({required this.circleOffsetdx});

  @override
  void paint(Canvas canvas, Size size) {
    //background text painter
    final backgroundtextPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: const TextSpan(
            text: "Loading...",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 34)));

    //prepare text
    backgroundtextPainter.layout(maxWidth: 152);
    //paint text
    backgroundtextPainter.paint(canvas, Offset.zero);

    //definition of the circle
    final Path path = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(circleOffsetdx, 20), radius: 20));
    // save the current layout of the canvas before cliping
    // the foreground text
    canvas.save();

    //clip the circle to constraint what will follow (the foreground text)
    canvas.clipPath(path);

    // foreground text painter
    final foregroundTextPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: "Loading...",
            style: TextStyle(
                color: Colors.white,
                background: ui.Paint()..color = Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 34)));

    foregroundTextPainter.layout(maxWidth: 152);
    foregroundTextPainter.paint(canvas, Offset.zero);
    //restore the initial layout
    //useful in case there are other things to draw
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
