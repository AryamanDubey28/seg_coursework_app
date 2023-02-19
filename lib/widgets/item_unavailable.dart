import 'dart:ui';

import 'package:flutter/material.dart';

// Widget created when an item is unavailable

//Blur image and display unavailable red icon
Stack makeUnavailable() {
  return Stack(
    key: const Key("unavailableImage"),
    children: <Widget>[
      ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: Icon(
              Icons.highlight_remove,
              size: 100,
              color: Colors.red,
            ),
          ),
        ),
      ),
    ],
  );
}
