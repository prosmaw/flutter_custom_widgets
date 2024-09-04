import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CardsStack extends StatefulWidget {
  const CardsStack({super.key});

  @override
  State<CardsStack> createState() => _CardsStackState();
}

class _CardsStackState extends State<CardsStack> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this);
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
    double cardWidth = width * 0.8;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stack cards"),
        ),
        body: GestureDetector(
          onTap: onCardTap,
          child: Center(
            child: SizedBox(
              width: width,
              height: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Flow(
                  delegate: FlowStackDelegate(
                    animation: controller,
                    screnWidth: width,
                    expand: expand,
                  ),
                  children: List.generate(3, (index) {
                    return Container(
                      height: cardHeight,
                      width: expand ? cardWidth : cardWidth - (index * 10),
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

  void onCardTap() {
    if (expand) {
      setState(() {
        expand = false;
      });
      final SpringSimulation springSimulation = SpringSimulation(
          const SpringDescription(mass: 1, stiffness: 90, damping: 8.0),
          1.0,
          0.0,
          0.0);
      controller.animateWith(springSimulation);
    } else if (!expand) {
      setState(() {
        expand = true;
      });
      final SpringSimulation springSimulation = SpringSimulation(
          const SpringDescription(mass: 1, stiffness: 90, damping: 8.0),
          0.0,
          1.0,
          0.0);
      controller.animateWith(springSimulation);
    }
  }
}

class FlowStackDelegate extends FlowDelegate {
  Animation<double> animation;
  double screnWidth;
  bool expand;

  FlowStackDelegate(
      {required this.animation, required this.screnWidth, required this.expand})
      : super(repaint: animation);
  @override
  void paintChildren(FlowPaintingContext context) {
    int childCount = context.childCount;
    double gap = context.getChildSize(0)!.height + 15;
    double childHeight = context.getChildSize(0)!.height;
    double height = context.size.height - 20;
    double firstPos = (height / 2 - (childHeight / 2)) - gap;
    double x, y;

    for (int i = childCount - 1; i >= 0; i--) {
      //default y
      double defY = (height / 2 - (childHeight / 2)) + (10 * i).toDouble();
      y = defY + (firstPos + (i * gap) - defY) * animation.value;
      x = expand ? (screnWidth * 0.05) : (screnWidth * 0.05) + (i * 5);
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
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
