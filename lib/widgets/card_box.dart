import 'package:flutter/material.dart';

class CardBox extends StatelessWidget {
  const CardBox(
      {super.key,
      required this.angle,
      required this.height,
      required this.width});

  final double angle;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 83, 80, 80),
              width: 1,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 5),
                  color: Color.fromARGB(255, 209, 203, 203),
                  spreadRadius: 1,
                  blurRadius: 8)
            ]),
      ),
    );
  }
}
