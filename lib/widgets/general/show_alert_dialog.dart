import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ShowAlertDialog extends StatelessWidget {
  String text;

  ShowAlertDialog({super.key, required this.text});

  static void show_dialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              message,
              style: TextStyle(fontSize: 24),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(); //cannot make showDialog into widget as it is a Flutter SDK method
  }
}
