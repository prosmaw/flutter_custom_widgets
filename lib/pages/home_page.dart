import 'package:custom_widgets/widgets/angular_gradient_button.dart';
import 'package:custom_widgets/widgets/blurred_list.dart';
import 'package:custom_widgets/widgets/card_fan_out_animation.dart';
import 'package:custom_widgets/widgets/cards_cascade_out.dart';
import 'package:custom_widgets/widgets/cards_stack.dart';
import 'package:custom_widgets/widgets/dots_loading.dart';
import 'package:custom_widgets/widgets/dropdown_menu.dart';
import 'package:custom_widgets/widgets/jump_slide.dart';
import 'package:custom_widgets/widgets/loading_animation.dart';
import 'package:custom_widgets/widgets/rotating_arcs.dart';
import 'package:custom_widgets/widgets/rotating_gradient_arc.dart';
import 'package:custom_widgets/widgets/stack_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Custom widgets",
          ),
        ),
        body: ListView.builder(
            itemCount: widgetsDemo.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(widgetsDemo[index].name),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: widgetsDemo[index].builder));
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                )));
  }
}

class Demo {
  String name;
  WidgetBuilder builder;

  Demo({required this.builder, required this.name});
}

List<Demo> widgetsDemo = [
  Demo(builder: (context) => const CustomDropdownMenu(), name: "Dropdown Menu"),
  Demo(
      builder: (context) => const RotatingGradientArc(),
      name: "Rotating Gradient Arc"),
  Demo(
      builder: (context) => const AngularGradientButton(),
      name: "Angular Gragient Button"),
  Demo(builder: (context) => const RotatingArcs(), name: "Rotating Arcs"),
  Demo(
      builder: (context) => const LoadingAnimation(),
      name: "Loading Animation"),
  Demo(builder: (context) => const DotsLoading(), name: "Dots  Loading"),
  Demo(builder: (context) => const JumpSlide(), name: "Jump and Slide"),
  Demo(builder: (context) => const FanOutAnimation(), name: "Fane out Cards"),
  Demo(
      builder: (context) => const CardsCascadeOut(), name: "Cascade out cards"),
  Demo(builder: (context) => const CardsStack(), name: "Stack cards"),
  Demo(builder: (context) => const StackList(), name: "Stack List"),
  Demo(builder: (context) => const BlurredList(), name: "Blurred List"),
];
