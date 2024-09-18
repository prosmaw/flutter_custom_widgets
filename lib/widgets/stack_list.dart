import 'package:custom_widgets/widgets/stack_item.dart';
import 'package:flutter/material.dart';

class StackList extends StatefulWidget {
  const StackList({super.key});

  @override
  State<StackList> createState() => _StackListState();
}

class _StackListState extends State<StackList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stack List"),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: ListView.builder(
            itemCount: 5, itemBuilder: (context, index) => const StackItem()),
      ),
    );
  }
}
