import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  late final Color? buttonCol;
  late final String? buttonName;

  MyButton(Color colIn, String name, {super.key}) {
    buttonCol = colIn;
    buttonName = name;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
