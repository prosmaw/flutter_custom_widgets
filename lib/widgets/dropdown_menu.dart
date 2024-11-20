import 'package:custom_widgets/widgets/dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({super.key});

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu>
    with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900));
  late AnimationController springController = AnimationController(vsync: this);

  late SpringSimulation springSimulation;

  bool isExpanded = false;
  Animation<double> opacity = const AlwaysStoppedAnimation(0);

  double baseHeight = 80; // height of the menu when not expanded

  Animation<double> selectedY = const AlwaysStoppedAnimation(0);
  Animation<double> selectedX = const AlwaysStoppedAnimation(0);

  int selected = 1;

  List<Map<String, dynamic>> dropdownItems = [
    {
      "title": "Sonnet 3.5",
      "detail": "Advanced reasoning",
      "icon": "assets/icons/claude.svg",
      "toUpgrade": true
    },
    {
      "title": "llama 3.2",
      "detail": "Verstatile problem-solving",
      "icon": "assets/icons/meta.svg",
      "toUpgrade": false
    },
    {
      "title": "GPT-4o",
      "detail": "Rapid text generation",
      "icon": "assets/icons/OpenAi.svg",
      "toUpgrade": false
    },
    {
      "title": "Gemini 1.5",
      "detail": "Efficient task completion",
      "icon": "assets/icons/gemini.svg",
      "toUpgrade": false
    },
  ];

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void onMenuTap(double selectedInitialX) {
    if (isExpanded) {
      setState(() {
        isExpanded = false;

        opacity = Tween<double>(begin: 1, end: 0).animate(animationController);

        animationController.forward(from: 0);

        springSimulation = SpringSimulation(
            const SpringDescription(mass: 1, stiffness: 100, damping: 12.0),
            1.0,
            0.0,
            0.0);

        selectedY = Tween<double>(begin: 0, end: (((selected) * 90)).toDouble())
            .animate(springController);

        selectedX = const AlwaysStoppedAnimation(0);

        springController.animateWith(springSimulation);
      });
    } else {
      setState(() {
        isExpanded = true;

        opacity = Tween<double>(begin: 0, end: 1).animate(animationController);

        animationController.forward(from: 0);

        selectedY = Tween<double>(
                begin: -(((selected + 1) * 90) + 15).toDouble(), end: 0)
            .animate(springController);

        selectedX = Tween<double>(begin: selectedInitialX, end: 0)
            .animate(springController);

        springSimulation = SpringSimulation(
            const SpringDescription(mass: 1, stiffness: 50, damping: 8.0),
            0.0,
            1.0,
            0.0);

        springController.animateWith(springSimulation);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double baseWidth = width * 0.5; // width of the menu when not expanded
    double expandWidth = width * 0.9;
    double initialx = (width * 0.25); // initial x position of the selected item
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Dropdown Menu"),
      ),
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Center(
              child: AnimatedBuilder(
                  animation: springController,
                  builder: (context, child) {
                    int itemsCount = dropdownItems.length;
                    double expandedHeight = (90 * itemsCount).toDouble();
                    return Container(
                      width: baseWidth +
                          (expandWidth - baseWidth) * (springController.value),
                      height: baseHeight +
                          (expandedHeight - baseHeight) *
                              (springController.value),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: isExpanded,
                              child: Opacity(
                                opacity: opacity.value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Choose Model",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 107, 107, 107),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.5),
                                    ),
                                    Material(
                                      child: Ink(
                                        width: 25,
                                        decoration: const ShapeDecoration(
                                          shape: CircleBorder(),
                                          color: Color.fromARGB(
                                              255, 174, 173, 184),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              onMenuTap(initialx);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: List.generate(dropdownItems.length,
                                      (index) {
                                    bool isSelected = selected == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected = index;
                                        });
                                        onMenuTap(initialx);
                                      },
                                      child: DropdownItem(
                                        isExpanded: isExpanded,
                                        title: dropdownItems[index]["title"],
                                        detail: dropdownItems[index]["detail"],
                                        icon: dropdownItems[index]["icon"],
                                        isSelected: isSelected,
                                        forUpgrade: dropdownItems[index]
                                            ["toUpgrade"],
                                        y: selectedY.value,
                                        x: selectedX.value,
                                      ),
                                    );
                                  }),
                                )),
                                if (!isExpanded)
                                  GestureDetector(
                                      onTap: () {
                                        onMenuTap(initialx);
                                      },
                                      child: Opacity(
                                        opacity: 1 - opacity.value,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black),
                                      )),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
