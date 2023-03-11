import 'package:flutter/material.dart';

class ErrorDialogHelper {
  late dynamic context;

  ErrorDialogHelper({required this.context});

  void show_alert_dialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              text,
              style: TextStyle(fontSize: 24),
            ),
          );
        });
  }
}
