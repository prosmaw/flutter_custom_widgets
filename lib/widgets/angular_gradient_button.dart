import 'package:custom_widgets/widgets/gradient_border.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AngularGradientButton extends StatefulWidget {
  const AngularGradientButton({
    super.key,
  });

  @override
  State<AngularGradientButton> createState() => _AngularGradientButtonState();
}

class _AngularGradientButtonState extends State<AngularGradientButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat();

  Gradient get borderGradient => LinearGradient(colors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
        Colors.pink
      ], transform: GradientRotation(_animationController.value * 2 * math.pi));
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          height: 65,
          width: 280,
        ),
        Positioned(
            top: 5,
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return GradientBorder(
                    gradient: borderGradient,
                    radius: 20,
                    size: const Size(280, 60),
                    strokeWidth: 5,
                  );
                })),
        Positioned(
          top: 0,
          child: Container(
            height: 60,
            width: 280,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.black,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside),
                gradient: const LinearGradient(colors: [
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.transparent
                ], transform: GradientRotation(math.pi / 2))),
          ),
        ),
        Positioned(
          top: 5,
          child: FilledButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll<Color>(
                      Color.fromARGB(255, 58, 56, 56)),
                  fixedSize: const WidgetStatePropertyAll<Size>(Size(280, 60)),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
              child: const Text(
                "Get started",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
        )
      ],
    );
  }
}
