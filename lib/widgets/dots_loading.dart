import 'package:flutter/material.dart';

class DotsLoading extends StatefulWidget {
  const DotsLoading({super.key});

  @override
  State<DotsLoading> createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<DotsLoading>
    with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  )..repeat(reverse: true);
  int count = 0;

  @override
  void initState() {
    super.initState();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse && count < 3) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              count++;
            });
          }
        });
      } else if (status != AnimationStatus.reverse && count == 2) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              count = 0;
            });
          }
        });
      }
      // print("anim count: $count");
    });
  }

  @override
  void dispose() {
    controller.removeStatusListener((status) {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bubles Loading"),
        ),
        body: Center(
          child: Flow(
              delegate: FlowDotDelegate(
                  animation: controller, childWidth: 30, count: count),
              children: List.generate(
                  3,
                  (index) => Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                      )).toList()),
        ));
  }
}

class FlowDotDelegate extends FlowDelegate {
  Animation<double> animation;
  double childWidth;
  int count;
  FlowDotDelegate(
      {required this.animation, required this.childWidth, required this.count})
      : super(repaint: animation);
  @override
  void paintChildren(FlowPaintingContext context) {
    double topPosition = 10;
    double spacing = 15 + childWidth;
    double width = context.size.width;
    for (int i = 0; i < context.childCount; ++i) {
      if (count == i) {
        topPosition = 10;
      } else {
        topPosition = 0;
      }
      context.paintChild(i,
          transform: Matrix4.translationValues(
              width / 2 + (i * spacing), topPosition * animation.value, 0));
    }
  }

  @override
  bool shouldRepaint(FlowDotDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
