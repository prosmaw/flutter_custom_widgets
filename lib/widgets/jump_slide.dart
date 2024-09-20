import 'package:flutter/material.dart';
import 'dart:math' as math;

class JumpSlide extends StatefulWidget {
  const JumpSlide({super.key});

  @override
  State<JumpSlide> createState() => _JumpSlideState();
}

class _JumpSlideState extends State<JumpSlide> with TickerProviderStateMixin {
  double boxHeight = 33.0;
  double boxWidth = 33.0;
  double spacing = 15.0;
  int boxesNumber = 5;
  double radius = 33;
  double containerWidth = 0;
  int currentPos = 3;

  late AnimationController jumpController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late AnimationController slideController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500));

  late AnimationController scaleController = AnimationController(vsync: this);

  late Animation<double> sliderX;

  List<Animation<double>> listTurns =
      List.filled(4, const AlwaysStoppedAnimation(-math.pi));
  List<Animation<double>> xScales =
      List.filled(4, const AlwaysStoppedAnimation(1));
  List<Animation<double>> yScales =
      List.filled(4, const AlwaysStoppedAnimation(1));

  TweenSequence<double> get xScaleTween => TweenSequence<double>([
        TweenSequenceItem(
            tween: Tween<double>(begin: 1, end: 1.3),
            weight: 15 * (currentPos + 1)),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.3, end: 0.8),
            weight: 15 * (currentPos + 1) + 10),
        TweenSequenceItem(
            tween: Tween<double>(begin: 0.8, end: 1),
            weight: 15 * (currentPos + 1) + 25),
      ]);

  TweenSequence<double> get yScaleTween => TweenSequence<double>([
        TweenSequenceItem(
            tween: Tween<double>(begin: 1, end: 0.7),
            weight: 15 * (currentPos + 1)),
        TweenSequenceItem(
            tween: Tween<double>(begin: 0.7, end: 1.4),
            weight: 15 * (currentPos + 1) + 10),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.4, end: 1),
            weight: 15 * (currentPos + 1) + 25),
      ]);

  @override
  void initState() {
    super.initState();

    sliderX = Tween<double>(begin: (boxWidth + spacing) * 4, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(slideController)
      ..addListener(() {
        setState(() {});
      });

    slideController.addStatusListener((status) async {
      if (status == AnimationStatus.forward) {
        for (int i = (listTurns.length - 1); i >= 0; i--) {
          currentPos = i;
          listTurns[i] = Tween<double>(begin: -math.pi, end: 0)
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);

          xScales[i] = xScaleTween
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);
          yScales[i] = yScaleTween
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);

          await jumpController.forward(from: 0);

          listTurns[i] = const AlwaysStoppedAnimation(0);
          xScales[i] = const AlwaysStoppedAnimation(1);
          yScales[i] = const AlwaysStoppedAnimation(1);
        }
      } else if (status == AnimationStatus.reverse) {
        for (int i = 0; i < listTurns.length; i++) {
          listTurns[i] = Tween<double>(begin: 0, end: -math.pi)
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);

          xScales[i] = xScaleTween
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);
          yScales[i] = yScaleTween
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);

          await jumpController.forward(from: 0);

          listTurns[i] = const AlwaysStoppedAnimation(-math.pi);
          xScales[i] = const AlwaysStoppedAnimation(1);
          yScales[i] = const AlwaysStoppedAnimation(1);
        }
      }
    });

    slideController.repeat(reverse: true);
  }

  @override
  void dispose() {
    slideController.removeStatusListener((status) {});
    jumpController.dispose();
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jump and Slide"),
      ),
      body: Center(
        child: SizedBox(
          height: (boxHeight * 2) + 10,
          width: 10 + (boxWidth + spacing) * 5,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: <Color>[
                  Color(0xFF1C9FFF),
                  Color(0xFF1FB1FD),
                  Color(0xFF22C7FB),
                  Color(0xFF23D3FB),
                  Color(0xFF23D3FB),
                ],
              ).createShader(bounds);
            },
            child:
                Stack(alignment: AlignmentDirectional.bottomStart, children: [
              ...List.generate(4, (index) {
                return Transform.translate(
                  offset: Offset(
                      (radius * math.cos(listTurns[index].value)) +
                          radius +
                          (boxWidth + spacing) * index,
                      (radius * math.sin(listTurns[index].value))),
                  child: Transform.rotate(
                    angle: listTurns[index].value,
                    child: Transform.scale(
                      scaleX: xScales[index].value,
                      scaleY: yScales[index].value,
                      child: Container(
                        width: boxWidth, //listWidth[index].value,
                        height: boxWidth, //listHeight[index].value,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                );
              }),
              Container(
                transform: Matrix4.translationValues(sliderX.value, 0, 0),
                width: boxHeight,
                height: boxWidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
