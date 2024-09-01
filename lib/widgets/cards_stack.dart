import 'package:flutter/material.dart';

class CardsStack extends StatefulWidget {
  const CardsStack({super.key});

  @override
  State<CardsStack> createState() => _CardsStackState();
}

class _CardsStackState extends State<CardsStack> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  bool expand = false;
  double cardHeight = 100;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stack cards"),
        ),
        body: GestureDetector(
          onTap: () {
            if (expand) {
              controller.animateBack(0.0,
                  curve: Curves.bounceOut,
                  duration: const Duration(milliseconds: 500));
              Future.delayed(
                  const Duration(milliseconds: 500),
                  () => setState(() {
                        expand = false;
                      }));
            } else if (!expand) {
              setState(() {
                expand = true;
              });
              controller.animateTo(1, curve: Curves.bounceOut);
            }
          },
          child: Flow(
            delegate: FlowStackDelegate(
                animation: controller,
                screenHeight: height,
                screnWidth: width,
                expand: expand),
            children: List.generate(
                3,
                (index) => Container(
                      height: cardHeight,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 83, 80, 80),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 5),
                                color: Color.fromARGB(255, 209, 203, 203),
                                spreadRadius: 1,
                                blurRadius: 8)
                          ]),
                    )),
          ),
        ));
  }
}

class FlowStackDelegate extends FlowDelegate {
  Animation<double> animation;
  double screenHeight;
  double screnWidth;
  bool expand;

  FlowStackDelegate(
      {required this.animation,
      required this.screenHeight,
      required this.screnWidth,
      required this.expand})
      : super(repaint: animation);
  @override
  void paintChildren(FlowPaintingContext context) {
    int childCount = context.childCount;
    double gap = context.getChildSize(0)!.height + 30;
    double childHeight = context.getChildSize(0)!.height;
    double firstPos = (screenHeight / 2 - childHeight) - gap;
    Animation<double> yAnim;
    for (int i = childCount - 1; i >= 0; i--) {
      double defY = (screenHeight / 2 - childHeight) + (10 * i).toDouble();
      if (expand) {
        yAnim = Tween<double>(begin: defY, end: firstPos + (i * gap))
            .animate(animation);
      } else {
        yAnim = Tween(begin: defY, end: defY).animate(animation);
      }
      context.paintChild(i,
          transform:
              Matrix4.translationValues(screnWidth * 0.1, yAnim.value, 0));
    }
  }

  @override
  bool shouldRepaint(FlowStackDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
