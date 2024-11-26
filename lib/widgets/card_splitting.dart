import 'package:flutter/material.dart';

class CardSplitting extends StatefulWidget {
  const CardSplitting({super.key});

  @override
  State<CardSplitting> createState() => _CardSplittingState();
}

class _CardSplittingState extends State<CardSplitting> {
  List<SplittingItemModel> items = [
    SplittingItemModel(
        title: "What is Interacting Design?",
        detail: "Designing how users interact with digital interfaces with"
            "intuitive experiences.",
        icon: Icons.ads_click),
    SplittingItemModel(
        title: "Principles & Patterns",
        detail: "Fundamental guidelines and repeated solutions that ensure"
            "consistency and usability  in design.",
        icon: Icons.layers),
    SplittingItemModel(
        title: "Usability & Accessibility",
        detail: "Focusing on making digital designs easy to use and accessible"
            "for everyone, including those with disabilities.",
        icon: Icons.touch_app),
    SplittingItemModel(
        title: "Prototyping & Testing",
        detail: "Designing how users interact with digital interfaces with"
            "intuitive experiences.",
        icon: Icons.send),
    SplittingItemModel(
        title: "UX Optimization",
        detail: "Improving the overall user experience by enhancing usability"
            "and satisfaction.",
        icon: Icons.speed),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cascade out Cards"),
      ),
      body: Center(
        child: Column(
          children: List.generate(items.length, (index) {
            return SplittingItem(
                title: items[index].title,
                detail: items[index].detail,
                icon: items[index].icon);
          }),
        ),
      ),
    );
  }
}

class SplittingItem extends StatefulWidget {
  final String title, detail;
  final IconData icon;
  const SplittingItem(
      {super.key,
      required this.title,
      required this.detail,
      required this.icon});

  @override
  State<SplittingItem> createState() => _SplittingItemState();
}

class _SplittingItemState extends State<SplittingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey),
          color: const Color.fromARGB(255, 252, 252, 252)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                color: const Color.fromARGB(255, 133, 132, 137),
              ),
              const SizedBox(width: 5),
              Text(
                widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 133, 132, 137),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SplittingItemModel {
  String title, detail;
  IconData icon;

  SplittingItemModel(
      {required this.title, required this.detail, required this.icon});
}
