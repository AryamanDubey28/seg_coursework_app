// This class was taken from https://medium.com/nerd-for-tech/showing-a-progress-indicator-easily-in-flutter-aa564eb0df5c.
// It was created by Rafael Perez on June 10th, 2021.

import 'package:flutter/material.dart';

// This widget is used to display a circular loading indicator in the middle of the screen.
class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  show(BuildContext context, {String text = 'Loading...'}) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.white,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(text),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  // This method can be used to easily dismount the circular loading indicator when no longer needed.
  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}
