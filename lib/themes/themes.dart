import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/theme_details.dart';

final defaultTheme = ThemeDetails(name: "Default theme", themeData: ThemeData(
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.teal[100],
));

final redTheme = ThemeDetails(name: "Red theme", themeData: ThemeData());

class CustomTheme with ChangeNotifier
{
  ThemeData _themeData = defaultTheme.themeData;

  ThemeData getTheme() => _themeData;

  List<ThemeDetails> getThemes()
  {
    return [defaultTheme, redTheme];
  }

  setTheme(ThemeDetails themeDetails) async
  {
    _themeData = themeDetails.themeData;
    notifyListeners();
  }

  // static ThemeData get defaultTheme {
  //   return ThemeData(
  //     primarySwatch: Colors.teal,
  //     scaffoldBackgroundColor: Colors.teal[100],
  //   );
  // }

  // static ThemeData get tealTheme {
  //   return ThemeData();
  // }
}