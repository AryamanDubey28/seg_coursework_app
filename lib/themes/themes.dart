import 'package:flutter/material.dart';

class CustomTheme with ChangeNotifier
{
  //idk if late should be here but leave it for now
  late ThemeData _themeData;

  ThemeData get getTheme => _themeData;

  setTheme(ThemeData themeData)
  {
    _themeData = themeData;
    notifyListeners();
  }

  static ThemeData get defaultTheme {
    return ThemeData();
  }

  static ThemeData get tealTheme {
    return ThemeData();
  }
}