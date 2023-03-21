import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  final String text;

  const ShowAlertDialog({super.key, required this.text});

  static void show_dialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              message,
              style: const TextStyle(fontSize: 24),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder(); //cannot make showDialog into widget as it is a Flutter SDK method
  }
}
