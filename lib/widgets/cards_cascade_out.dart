import 'package:custom_widgets/widgets/card_box.dart';
import 'package:flutter/material.dart';
//import 'dart:math' as math;

class CardsCascadeOut extends StatefulWidget {
  const CardsCascadeOut({super.key});

  @override
  State<CardsCascadeOut> createState() => _CardsCascadeOutState();
}

class _CardsCascadeOutState extends State<CardsCascadeOut>
    with TickerProviderStateMixin {
  List<double> cardsLeftMoves = [-75, -75, -75, -75, -75];
  List<double> endAngles = [-0.4, -0.3, -0.2, -0.1, 0];
  List<double> beginAngles = [-0.4, -0.3, -0.2, 0.1, 0];
  List<double> cardsTopMoves = [-200, -200, -200, -200, -200];
  List<Size> cardsSize = [
    const Size(150, 200),
    const Size(150, 200),
    const Size(150, 200),
    const Size(150, 200),
    const Size(150, 200),
  ];

  void _onLongPress(double width, double height) {
    setState(() {
      cardsLeftMoves[3] = (-width / 2) + 10;
      cardsTopMoves[4] = -220;
      for (int i = 2; i >= 0; i--) {
        cardsLeftMoves[i] = cardsLeftMoves[i + 1] + 110;
      }
      for (int i = 0; i < endAngles.length - 1; i++) {
        endAngles[i] = 0;
      }
      for (int i = 0; i < cardsTopMoves.length - 1; i++) {
        cardsTopMoves[i] = 10;
      }
      for (int i = 0; i < cardsSize.length - 1; i++) {
        cardsSize[i] = const Size(100, 150);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cascade out Cards"),
      ),
      body: Center(
        child: GestureDetector(
          onLongPress: () {
            _onLongPress(width, height);
          },
          onLongPressEnd: (details) {
            setState(() {
              cardsLeftMoves = [-75, -75, -75, -75, -75];
              endAngles = [-0.4, -0.3, -0.2, -0.1, 0];
              cardsTopMoves = [-200, -200, -200, -200, -200];
              cardsSize = [
                const Size(150, 200),
                const Size(150, 200),
                const Size(150, 200),
                const Size(150, 200),
                const Size(150, 200),
              ];
            });
          },
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
                alignment: Alignment.center,
                children: List.generate(
                  cardsLeftMoves.length,
                  (index) => TweenAnimationBuilder(
                      tween: Tween<double>(
                          begin: (height / 2) - 200,
                          end: (height / 2) + cardsTopMoves[index]),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, top, child) {
                        return TweenAnimationBuilder(
                            tween: Tween<double>(
                                begin: (width / 2) - 75,
                                end: (width / 2) + cardsLeftMoves[index]),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, left, child) {
                              return Positioned(
                                left: left,
                                top: top,
                                child: TweenAnimationBuilder(
                                    tween: Tween<double>(
                                        begin: beginAngles[index],
                                        end: endAngles[index]),
                                    duration: const Duration(milliseconds: 300),
                                    builder: (context, angle, child) {
                                      return TweenAnimationBuilder(
                                          tween: Tween<Size>(
                                              begin: const Size(150, 200),
                                              end: cardsSize[index]),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          builder: (context, size, child) {
                                            return CardBox(
                                              height: size.height,
                                              width: size.width,
                                              angle: angle,
                                            );
                                          });
                                    }),
                              );
                            });
                      }),
                )),
          ),
        ),
      ),
    );
  }
}
