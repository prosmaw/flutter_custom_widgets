import 'package:flutter/material.dart';

class JumpSlide extends StatefulWidget {
  const JumpSlide({super.key});

  @override
  State<JumpSlide> createState() => _JumpSlideState();
}

class _JumpSlideState extends State<JumpSlide> with TickerProviderStateMixin {
  double boxHeight = 50.0;
  double boxWidth = 50.0;
  double spacing = 15.0;
  int boxesNumber = 5;
  double containerWidth = 0;
  late AnimationController jumpController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late AnimationController slideController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500))
    ..repeat(reverse: true);
  late Animation<double> sliderX;
  // List<Animation<double>> listWidth =
  //     List.filled(4, const AlwaysStoppedAnimation(50));
  // List<Animation<double>> listHeight =
  //     List.filled(4, const AlwaysStoppedAnimation(50));
  List<Animation<double>> boxesX =
      List.filled(4, const AlwaysStoppedAnimation(0));
  List<Animation<double>> boxesY =
      List.filled(4, const AlwaysStoppedAnimation(0));
  List<Animation<double>> listTurns =
      List.filled(4, const AlwaysStoppedAnimation(0));
  int currentPos = 3;

  @override
  void initState() {
    super.initState();

    sliderX = Tween<double>(begin: 0, end: -270)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(slideController)
      ..addListener(() {
        setState(() {});
      });
    jumpController.forward();
    slideController.addStatusListener((status) async {
      if (status == AnimationStatus.forward) {
        for (int i = (listTurns.length - 1); i >= 0; i--) {
          listTurns[i] = Tween<double>(begin: 0, end: 0.75)
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);
          boxesX[i] = Tween<double>(begin: 0, end: boxWidth + spacing)
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);
          boxesY[i] = TweenSequence([
            TweenSequenceItem(
                tween: Tween<double>(begin: 0, end: -boxHeight * 1.5),
                weight: 0.5),
            TweenSequenceItem(
                tween: Tween<double>(begin: -boxHeight * 1.5, end: 0),
                weight: 0.5),
          ]).chain(CurveTween(curve: Curves.easeInOut)).animate(jumpController);
          // listHeight[i] = Tween<double>(begin: 50, end: (50 * 0.7))
          //     .chain(CurveTween(curve: Curves.easeInOut))
          //     .animate(jumpController);
          // listWidth[i] = Tween<double>(begin: 50, end: (50 * 1.3))
          //     .chain(CurveTween(curve: Curves.easeInOut))
          //     .animate(jumpController);
          await jumpController.forward(from: 0);
          listTurns[i] = const AlwaysStoppedAnimation(0.75);
          boxesX[i] = AlwaysStoppedAnimation(boxWidth + spacing);
          boxesY[i] = const AlwaysStoppedAnimation(0);
          // listHeight[i] = const AlwaysStoppedAnimation(50);
          // listWidth[i] = const AlwaysStoppedAnimation(50);
        }
      } else if (status == AnimationStatus.reverse) {
        for (int i = 0; i < listTurns.length; i++) {
          listTurns[i] = Tween<double>(begin: 0.75, end: 0)
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);
          boxesX[i] = Tween<double>(begin: boxWidth + spacing, end: 0)
              .chain(CurveTween(curve: Curves.easeInOut))
              .animate(jumpController);
          boxesY[i] = TweenSequence([
            TweenSequenceItem(
                tween: Tween<double>(begin: 0, end: -boxHeight * 1.5),
                weight: 0.5),
            TweenSequenceItem(
                tween: Tween<double>(begin: -boxHeight * 1.5, end: 0),
                weight: 0.5),
          ]).chain(CurveTween(curve: Curves.easeInOut)).animate(jumpController);
          // listHeight[i] = Tween<double>(begin: 50, end: (50 * 0.7))
          //     .chain(CurveTween(curve: Curves.easeInOut))
          //     .animate(jumpController);
          // listWidth[i] = Tween<double>(begin: 50, end: (50 * 1.3))
          //     .chain(CurveTween(curve: Curves.easeInOut))
          //     .animate(jumpController);
          await jumpController.forward(from: 0);
          listTurns[i] = const AlwaysStoppedAnimation(0);
          boxesX[i] = const AlwaysStoppedAnimation(0);
          boxesY[i] = const AlwaysStoppedAnimation(0);
          // listHeight[i] = const AlwaysStoppedAnimation(50);
          // listWidth[i] = const AlwaysStoppedAnimation(50);
        }
      }
    });
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
          width: (boxWidth * boxesNumber) + (spacing * boxesNumber),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: <Color>[
                  Color(0xFF1C9FFF),
                  Color(0xFF1FB1FD),
                  Color(0xFF22C7FB),
                  Color(0xFF23D3FB),
                ],
              ).createShader(bounds);
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(4, (index) {
                      return Container(
                        transform: Matrix4.translationValues(
                            boxesX[index].value, boxesY[index].value, 0),
                        width: 50, //listWidth[index].value,
                        height: 50, //listHeight[index].value,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
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
      ),
    );
  }
}
