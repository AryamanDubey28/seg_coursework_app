import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

/// Widget created when an item is unavailable.
/// Blur image and display unavailable red icon
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
            child: const DecoratedIcon(
              icon: Icon(
                Icons.clear,
                color: Colors.red,
                size: 100,
              ),
              decoration: IconDecoration(border: IconBorder(width: 5)),
            ),
          ),
        ),
      ),
    ],
  );
}
