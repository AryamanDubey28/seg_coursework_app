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
    backgroundColor: Colors.teal[300],
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.teal[400]),
      iconColor: MaterialStatePropertyAll(Colors.white),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
    ),
  ),
  dividerColor: Colors.white70,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.teal[400]),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.teal[300]
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
  // ),
  listTileTheme: ListTileThemeData(textColor: Colors.white, iconColor: Colors.white)

));

final redTheme = ThemeDetails(name: "Red theme", themeData: ThemeData(
  primarySwatch: Colors.red,
  scaffoldBackgroundColor: Colors.red[100],
  appBarTheme: AppBarTheme(
    color: Colors.red[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.red[300],
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.red[400]),
      iconColor: MaterialStatePropertyAll(Colors.white),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
    ),
  ),
  dividerColor: Colors.white70,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.red[400]),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.red[300]
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
  // )
  listTileTheme: ListTileThemeData(textColor: Colors.white, iconColor: Colors.white)
));

final deepPurpleTheme = ThemeDetails(name: "Purple theme", themeData: ThemeData(
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.deepPurple[100],
  appBarTheme: AppBarTheme(
    color: Colors.deepPurple[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple[300],
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.deepPurple[400]),
      iconColor: MaterialStatePropertyAll(Colors.white),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
    ),
  ),
  dividerColor: Colors.white70,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.deepPurple[400]),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.deepPurple[300]
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
  // )
  listTileTheme: ListTileThemeData(textColor: Colors.white, iconColor: Colors.white)
));

final lightGreenTheme = ThemeDetails(name: "Light green theme", themeData: ThemeData(
  primarySwatch: Colors.lightGreen,
  scaffoldBackgroundColor: Colors.lightGreen[100],
  appBarTheme: AppBarTheme(
    color: Colors.lightGreen[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.lightGreen[300],
    foregroundColor: Colors.black,
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.black), 
      backgroundColor: MaterialStatePropertyAll(Colors.lightGreen[400]),
      iconColor: MaterialStatePropertyAll(Colors.black),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.black)),
    ),
  ),
  dividerColor: Colors.white70,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.lightGreen[400]),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.lightGreen[300]
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
  // )
  listTileTheme: ListTileThemeData(textColor: Colors.black, iconColor: Colors.black)
));

final greenTheme = ThemeDetails(name: "Green theme", themeData: ThemeData(
  primarySwatch: Colors.green,
  scaffoldBackgroundColor: Colors.green[100],
  appBarTheme: AppBarTheme(
    color: Colors.green[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green[300],
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.green[400]),
      iconColor: MaterialStatePropertyAll(Colors.white),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
    ),
  ),
  dividerColor: Colors.white70,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.green[400]),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.green[300]
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
  // )
  listTileTheme: ListTileThemeData(textColor: Colors.white, iconColor: Colors.white)
));

final deepOrangeTheme = ThemeDetails(name: "Orange theme", themeData: ThemeData(
  primarySwatch: Colors.deepOrange,
  scaffoldBackgroundColor: Colors.deepOrange[100],
  appBarTheme: AppBarTheme(
    color: Colors.deepOrange[300],
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepOrange[300],
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.deepOrange[400]),
      iconColor: MaterialStatePropertyAll(Colors.white),
      textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
    ),
  ),
  dividerColor: Colors.white70,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white), 
      backgroundColor: MaterialStatePropertyAll(Colors.deepOrange[400]),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.deepOrange[300]
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
  // )
  listTileTheme: ListTileThemeData(textColor: Colors.white, iconColor: Colors.white)
));

final darkTheme = ThemeDetails(name: "Dark theme", themeData: ThemeData.dark());



class CustomTheme with ChangeNotifier
{
  ThemeData _themeData = defaultTheme.themeData;

  ThemeData getTheme() => _themeData;

  List<ThemeDetails> getThemes()
  {
    return [defaultTheme, redTheme, deepPurpleTheme, lightGreenTheme, greenTheme, deepOrangeTheme];
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