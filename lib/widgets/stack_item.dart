import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class StackItem extends StatefulWidget {
  const StackItem({super.key});

  @override
  State<StackItem> createState() => _StackListState();
}

class _StackListState extends State<StackItem> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
  );
  late SpringSimulation springSimulation;
  bool expand = false;
  double cardHeight = 100;
  double flowHeight = 140;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        flowHeight = 140 + (350 - 140) * controller.value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double cardWidth = width * 0.8;
    return GestureDetector(
      onTap: onCardTap,
      child: SizedBox(
        width: width,
        height: flowHeight,
        child: Align(
          alignment: Alignment.topCenter,
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
    );
  }

  void onCardTap() {
    if (expand) {
      springSimulation = SpringSimulation(
          const SpringDescription(mass: 1, stiffness: 90, damping: 8.0),
          1.0,
          0.0,
          0.0);
      controller.animateWith(springSimulation);
      setState(() {
        expand = false;
      });
    } else if (!expand) {
      setState(() {
        expand = true;
      });
      springSimulation = SpringSimulation(
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
    double gap = context.getChildSize(0)!.height + 10;
    double x, y;

    for (int i = childCount - 1; i >= 0; i--) {
      //default y
      double defY = (10 * i).toDouble();

      y = defY + (i * gap * animation.value);
      x = !expand ? (screnWidth * 0.05) + (i * 5) : (screnWidth * 0.05);
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
