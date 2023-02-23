import 'package:flutter/material.dart';

///This model allows for easy handling of the themes. It saves a name and a ThemeData for each theme.
class ThemeDetails {
  final String name;
  final ThemeData themeData;

  ThemeDetails({required this.name, required this.themeData});
}