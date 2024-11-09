import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({super.key});

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu>
    with TickerProviderStateMixin {
  late AnimationController animation = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  bool isExpanded = false;
  Animation<double> opacity = const AlwaysStoppedAnimation(0);

  int selected = 2;

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
      "detail": "Verstatile problem-solving",
      "icon": "assets/icons/OpenAi.svg",
      "toUpgrade": false
    },
    {
      "title": "Gemini 1.5 pro",
      "detail": "Verstatile problem-solving",
      "icon": "assets/icons/gemini.svg",
      "toUpgrade": false
    },
  ];

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Dropdown Menu"),
      ),
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Align(
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isExpanded ? width * 0.9 : width * 0.5,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: isExpanded,
                        child: Opacity(
                          opacity: opacity.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Choose Model",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 107, 107, 107),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.5),
                              ),
                              Material(
                                child: Ink(
                                  width: 25,
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Color.fromARGB(255, 174, 173, 184),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        animation.forward(from: 0);

                                        setState(() {
                                          isExpanded = false;
                                          opacity =
                                              Tween<double>(begin: 1, end: 0)
                                                  .animate(animation);
                                          animation.forward(from: 0);
                                        });
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
                        children: [
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: dropdownItems.length,
                                itemBuilder: (context, index) {
                                  bool isSelected = selected == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                        isExpanded = false;
                                      });
                                    },
                                    child: DropdownItem(
                                      isExpanded: isExpanded,
                                      title: dropdownItems[index]["title"],
                                      detail: dropdownItems[index]["detail"],
                                      icon: dropdownItems[index]["icon"],
                                      isSelected: isSelected,
                                      forUpgrade: dropdownItems[index]
                                          ["toUpgrade"],
                                    ),
                                  );
                                }),
                          ),
                          if (!isExpanded)
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = true;
                                    opacity = Tween<double>(begin: 0, end: 1)
                                        .animate(animation);
                                    animation.forward(from: 0);
                                  });
                                },
                                child: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class DropdownItem extends StatefulWidget {
  final String title, detail, icon;
  final bool isSelected;
  final bool forUpgrade;
  final bool isExpanded;
  const DropdownItem({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.detail,
    required this.icon,
    required this.isSelected,
    required this.forUpgrade,
  });

  @override
  State<DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem>
    with TickerProviderStateMixin {
  late AnimationController itemController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  Animation<double> opacity = const AlwaysStoppedAnimation(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isExpanded) {
        print("debut");
        setState(() {
          opacity = Tween<double>(begin: 0, end: 1).animate(itemController);
        });
        print(opacity.value);
        print("fin");
      } else if (!widget.isExpanded && !widget.isSelected) {
        setState(() {
          opacity = Tween<double>(begin: 1, end: 0).animate(itemController);
        });
      } else {
        setState(() {
          opacity = const AlwaysStoppedAnimation(1);
        });
      }
    });
    itemController.forward(from: 0);
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: itemController,
        builder: (context, child) {
          return InkWell(
            child: Visibility(
              visible: widget.isExpanded || widget.isSelected,
              child: Opacity(
                opacity: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.isExpanded ? 10 : 0,
                      bottom: widget.isExpanded ? 10 : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.grey,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset(
                                widget.icon,
                                fit: BoxFit.fill,
                                height: 30,
                                width: 30,
                                colorFilter: const ColorFilter.mode(
                                    Colors.black, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.5,
                                    color: Color.fromARGB(255, 118, 118, 118)),
                              ),
                              if (widget.isExpanded)
                                Text(
                                  widget.detail,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color:
                                          Color.fromARGB(255, 118, 118, 118)),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (widget.isExpanded)
                        widget.forUpgrade
                            ? Row(
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.grey,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                    ),
                                    child: Center(
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignOutside)),
                                          child: const Icon(
                                            Icons.north_east_outlined,
                                            size: 18,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.grey,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                    ),
                                    child: const Center(
                                      child: Text("Upgrade",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black)),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: widget.isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 2.5,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside),
                                ),
                                child: widget.isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : null,
                              )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
