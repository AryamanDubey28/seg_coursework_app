import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/theme_details.dart';

final defaultTheme = ThemeDetails(name: "Default theme", themeData: ThemeData(
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.teal[100],
  appBarTheme: AppBarTheme(
    color: Colors.teal[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.teal,
  ),
  iconTheme: IconThemeData(
    color: Colors.teal,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.teal[400]),
    ),
  ),
  dividerColor: Colors.white70,

));

final redTheme = ThemeDetails(name: "Red theme", themeData: ThemeData(
  primaryColor: Colors.red,
  scaffoldBackgroundColor: Colors.red[100],
  appBarTheme: AppBarTheme(
    color: Colors.red[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.red,
  ),
  iconTheme: IconThemeData(
    color: Colors.red,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.red[400]),
    ),
  ),
  dividerColor: Colors.white70,
  

));

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