import 'package:custom_widgets/data/card_splitting_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CardSplitting extends StatefulWidget {
  const CardSplitting({super.key});

  @override
  State<CardSplitting> createState() => _CardSplittingState();
}

class _CardSplittingState extends State<CardSplitting>
    with TickerProviderStateMixin {
  int itemSelected = -1;
  int lastSlected = -1;

  late AnimationController controller = AnimationController(vsync: this);

  SpringSimulation springSimulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 150, damping: 5.0),
      0.0,
      1.0,
      0.0);

  //space between item title and detail
  Animation<double> spaceTween = const AlwaysStoppedAnimation(0);
  //angle of the arrow icon
  Animation<double> angleTween = const AlwaysStoppedAnimation(0);

  void onItemClicked(bool isExpanded, int index) {
    if (isExpanded) {
      //collapse the selected item
      setState(() {
        spaceTween = Tween(begin: 10.0, end: 0.0).animate(controller);
        angleTween = Tween(begin: 3.14, end: 0.0).animate(controller);

        controller.animateWith(springSimulation);

        lastSlected = itemSelected;
        itemSelected = -1;
      });
    } else {
      //expand the selected item
      setState(() {
        lastSlected = itemSelected;
        itemSelected = index;

        controller.animateWith(springSimulation);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Splitting"),
      ),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Center(
              child: SizedBox(
                width: width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(items.length, (index) {
                    //expand the selected item
                    bool isExpanded = index == itemSelected;

                    //isFirst is used to set the top border color
                    bool isFirst = index == 0 || //first item
                        index ==
                            itemSelected + 1 || //item below the selected item
                        index == itemSelected; //selected item

                    //isLast is used to set the bottom border color
                    bool isLast = index == items.length - 1 ||
                        index == itemSelected - 1 ||
                        index == itemSelected;

                    //update space and angle tween for the selected item
                    if (itemSelected == index) {
                      spaceTween =
                          Tween(begin: 0.0, end: 10.0).animate(controller);
                      angleTween =
                          Tween(begin: 0.0, end: 3.14).animate(controller);
                    } else if (index == lastSlected) {
                      //update space and angle tween for the last selected item
                      spaceTween =
                          Tween(begin: 10.0, end: 0.0).animate(controller);
                      angleTween =
                          Tween(begin: 3.14, end: 0.0).animate(controller);
                    } else {
                      //set space and angle tween to default
                      spaceTween = const AlwaysStoppedAnimation(0);
                      angleTween = const AlwaysStoppedAnimation(0);
                    }
                    return GestureDetector(
                      onTap: () {
                        onItemClicked(isExpanded, index);
                      },
                      child: SplittingItem(
                        title: items[index].title,
                        detail: items[index].detail,
                        icon: items[index].icon,
                        isExpanded: isExpanded,
                        isFirst: isFirst,
                        isLast: isLast,
                        space: spaceTween.value,
                        angle: angleTween.value,
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
    );
  }
}

class SplittingItem extends StatelessWidget {
  final String title, detail;
  final IconData icon;
  final bool isExpanded, isFirst, isLast;
  final double space, angle;
  const SplittingItem(
      {super.key,
      required this.title,
      required this.isExpanded,
      required this.detail,
      required this.icon,
      required this.isFirst,
      required this.isLast,
      required this.angle,
      required this.space});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: isExpanded ? const EdgeInsets.symmetric(vertical: 10) : null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? 20 : 0),
              topRight: Radius.circular(isFirst ? 20 : 0),
              bottomLeft: Radius.circular(isLast ? 20 : 0),
              bottomRight: Radius.circular(isLast ? 20 : 0)),
          border: Border(
              left: const BorderSide(color: Colors.grey),
              right: const BorderSide(color: Colors.grey),
              top: isFirst
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
              bottom: isLast
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none),
          color: const Color.fromARGB(255, 252, 252, 252)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: const Color.fromARGB(255, 133, 132, 137),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                    angle: angle,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                      color: Color.fromARGB(255, 133, 132, 137),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: space),
          isExpanded
              ? Text(
                  detail,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 94, 94, 96)),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
