import 'package:flutter/material.dart';

class CardsStack extends StatefulWidget {
  const CardsStack({super.key});

  @override
  State<CardsStack> createState() => _CardsStackState();
}

class _CardsStackState extends State<CardsStack> with TickerProviderStateMixin {
  Duration duration = const Duration(milliseconds: 800);
  late AnimationController controller =
      AnimationController(vsync: this, duration: duration);
  bool expand = false;
  bool resize = false;
  double cardHeight = 100;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    double cardWidth = width * 0.8;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stack cards"),
        ),
        body: GestureDetector(
          onTap: () {
            if (expand) {
              setState(() {
                resize = false;
              });
              controller.animateBack(0.0,
                  curve: Curves.elasticOut, duration: duration);
              Future.delayed(
                  duration,
                  () => setState(() {
                        expand = false;
                      }));
            } else if (!expand) {
              setState(() {
                expand = true;
                resize = true;
              });
              controller.animateTo(1, curve: Curves.elasticOut);
            }
          },
          child: Center(
            child: SizedBox(
              width: width,
              height: expand ? 380 : 140,
              child: Align(
                alignment: Alignment.center,
                child: Flow(
                  delegate: FlowStackDelegate(
                      animation: controller,
                      screnWidth: width,
                      expand: expand,
                      resize: resize),
                  children: List.generate(3, (index) {
                    return Container(
                      height: cardHeight,
                      width: resize ? cardWidth : cardWidth - (index * 10),
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
                    );
                  }),
                ),
              ),
            ),
          ),
        ));
  }
}

class FlowStackDelegate extends FlowDelegate {
  Animation<double> animation;
  double screnWidth;
  bool expand, resize;

  FlowStackDelegate(
      {required this.animation,
      required this.screnWidth,
      required this.resize,
      required this.expand})
      : super(repaint: animation);
  @override
  void paintChildren(FlowPaintingContext context) {
    int childCount = context.childCount;
    double gap = context.getChildSize(0)!.height + 30;
    double childHeight = context.getChildSize(0)!.height;
    //flow height
    double height = expand ? 360 : 120;
    double firstPos = (height / 2 - (childHeight / 2)) - gap;
    Animation<double> yAnim;
    double x;

    for (int i = childCount - 1; i >= 0; i--) {
      //default y
      double defY = (height / 2 - (childHeight / 2)) + (10 * i).toDouble();

      if (expand) {
        yAnim = Tween<double>(begin: defY, end: firstPos + (i * gap))
            .animate(animation);
      } else {
        yAnim = Tween(begin: defY, end: defY).animate(animation);
      }
      x = resize ? (screnWidth * 0.05) : (screnWidth * 0.05) + (i * 5);
      context.paintChild(i,
          transform: Matrix4.translationValues(x, yAnim.value, 0));
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    //slightly widder than the children for the shadow to appear
    return Size(screnWidth * 0.9, double.infinity);
  }

  @override
  bool shouldRepaint(FlowStackDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
