import 'package:custom_widgets/widgets/angular_gradient_button.dart';
import 'package:custom_widgets/widgets/rotating_gradient_arc.dart';
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
  Demo(
      builder: (context) => const RotatingGradientArc(),
      name: "Rotating Gradient Arc"),
  Demo(
      builder: (context) => const AngularGradientButton(),
      name: "Angular Gragient Button")
];
