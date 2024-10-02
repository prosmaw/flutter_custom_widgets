import 'dart:ui';

import 'package:custom_widgets/utils/constants.dart';
import 'package:flutter/material.dart';

class BlurredList extends StatefulWidget {
  const BlurredList({super.key});

  @override
  State<BlurredList> createState() => _BlurredListState();
}

class _BlurredListState extends State<BlurredList>
    with TickerProviderStateMixin {
  late AnimationController positionController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  Constants constants = Constants();
  double cardHeight = 100;
  double boxHeight = 320;
  double primaryBoxHeight = 380;
  int next = 0;

  List<Animation<double>> cardsPosition = [];

  List<BlurredCard> blurredCards = [];

  void updateList(double width) async {
    if (blurredCards.length >= 3) {
      setState(() {
        for (int i = 0; i < 3; i++) {
          cardsPosition[i] = Tween<double>(
                  begin: i * (cardHeight + 10),
                  end: (i - 1) * (cardHeight + 10))
              .animate(positionController);
        }

        cardsPosition.add(Tween<double>(
                begin: 3 * (cardHeight + 10), end: (3 - 1) * (cardHeight + 10))
            .animate(positionController));

        blurredCards.add(BlurredCard(
          width: width,
          cost: constants.blurredListComponent[next]["cost"].toString(),
          icon: constants.blurredListComponent[next]["icon"],
          ref: constants.blurredListComponent[next]["ref"],
          height: cardHeight,
        ));
      });

      await positionController.animateTo(1);

      setState(() {
        blurredCards.removeAt(0);
        cardsPosition.removeAt(0);
        next += 1;
      });
    } else {
      setState(() {
        cardsPosition.add(AlwaysStoppedAnimation(next * (cardHeight + 10)));

        blurredCards.add(BlurredCard(
          width: width,
          cost: constants.blurredListComponent[next]["cost"].toString(),
          icon: constants.blurredListComponent[next]["icon"],
          ref: constants.blurredListComponent[next]["ref"],
          height: cardHeight,
        ));

        next += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blurred List"),
      ),
      body: Center(
          child: SizedBox(
        height: primaryBoxHeight,
        width: width,
        child: Stack(
          children: [
            ...List.generate(blurredCards.length, (index) {
              return Positioned(
                  left: width * 0.1,
                  top: cardsPosition[index].value,
                  child: blurredCards[index]);
            }),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    updateList(width);
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.add,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      )),
    );
  }
}

class BlurredCard extends StatefulWidget {
  const BlurredCard(
      {super.key,
      required this.width,
      required this.height,
      required this.cost,
      required this.icon,
      required this.ref});

  final double width, height;
  final String icon, cost, ref;

  @override
  State<BlurredCard> createState() => _BlurredCardState();
}

class _BlurredCardState extends State<BlurredCard>
    with TickerProviderStateMixin {
  late AnimationController blurController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late Animation<double> sigmaTween =
      Tween<double>(begin: 5.0, end: 0).animate(blurController);
  late Animation<double> opacityAnimation =
      Tween<double>(begin: 0, end: 1).animate(blurController);

  @override
  void initState() {
    super.initState();
    blurController.animateTo(1);
  }

  @override
  void dispose() {
    blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: blurController,
        builder: (context, child) {
          return Opacity(
            opacity: opacityAnimation.value,
            child: SizedBox(
              width: widget.width * 0.85,
              height: widget.height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Card(
                      color: Colors.white,
                      elevation: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 246, 244, 249),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(widget.icon))),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$ ${widget.cost}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23),
                                ),
                                Text(
                                  widget.ref,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: sigmaTween.value,
                              sigmaY: sigmaTween.value),
                          child: const Opacity(
                            opacity: 0,
                          )))
                ],
              ),
            ),
          );
        });
  }
}
