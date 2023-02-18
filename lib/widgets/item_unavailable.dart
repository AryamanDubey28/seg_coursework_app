import 'package:flutter/material.dart';

Stack makeUnavailable() {
  return Stack(
    key: const Key("unavailableImage"),
    children: const <Widget>[
      Positioned(
        left: 25.0,
        bottom: 0,
        child: Text('Unavailable',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            )),
      ),
      Positioned(
        left: 25.0,
        bottom: 10.0,
        child: Icon(
          Icons.highlight_remove,
          size: 70,
          color: Colors.red,
        ),
      ),
    ],
  );
}
