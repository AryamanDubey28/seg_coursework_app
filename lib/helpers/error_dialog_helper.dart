import 'package:flutter/material.dart';

// Helps other classes show simple error dialogs while avoiding code duplication.
class ErrorDialogHelper {
  late dynamic context;

  ErrorDialogHelper({required this.context});

  void showAlertDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Text(
              text,
              style: const TextStyle(fontSize: 24),
            ),
          );
        });
  }
}
