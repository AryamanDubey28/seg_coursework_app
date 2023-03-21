import 'package:flutter/material.dart';

///Shows snackbar given the message.
class SnackBarManager {
  static void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}