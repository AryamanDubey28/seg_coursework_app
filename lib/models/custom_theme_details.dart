import 'package:flutter/material.dart';

///This model allows for easy handling of the themes. It saves a name and color configuration for each object.
///It's used to manage themes and return a ThemeData of the object.
class CustomThemeDetails {
  final String name;
  final Color? menuColor;
  final Color? backgroundColor;
  final Color? buttonsColor;
  final Color? iconsAndTextsColor;

  CustomThemeDetails({this.name = "Custom theme", 
  this.menuColor = Colors.transparent, 
  this.backgroundColor = Colors.transparent, 
  this.buttonsColor = Colors.transparent, 
  this.iconsAndTextsColor = Colors.transparent});

  ///This function is used to compare this theme with another theme.
  bool equals(CustomThemeDetails other)
  {
    return name == other.name && 
    menuColor == other.menuColor && 
    backgroundColor == other.backgroundColor &&
    buttonsColor == other.backgroundColor &&
    iconsAndTextsColor == other.iconsAndTextsColor;
  }

  ///This is used to get the primarySwatch of any color.
  MaterialColor getColorSwatch(Color color) {
    if (color is MaterialColor) {
      return color;
    } 
    else {
      return MaterialColor(
        color.value,
        <int, Color>{
          50: color.withOpacity(0.1),
          100: color.withOpacity(0.2),
          200: color.withOpacity(0.3),
          300: color.withOpacity(0.4),
          400: color.withOpacity(0.5),
          500: color.withOpacity(0.6),
          600: color.withOpacity(0.7),
          700: color.withOpacity(0.8),
          800: color.withOpacity(0.9),
          900: color.withOpacity(1),
        },
      );
    }
  }

  ///This returns the ThemeData based on the color configurations of the object.
  ThemeData getCustomThemeData()
  {
    IconThemeData iconTheme = IconThemeData(
      color: iconsAndTextsColor,
    );
    return ThemeData(
      primarySwatch: getColorSwatch(menuColor!),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: iconsAndTextsColor, fontWeight: FontWeight.bold, fontSize: 25),
        color: menuColor,
        elevation: 0,
        iconTheme: iconTheme,
        actionsIconTheme: iconTheme
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: buttonsColor,
        foregroundColor: iconsAndTextsColor,
      ),
      iconTheme: iconTheme,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(iconsAndTextsColor), 
          backgroundColor: MaterialStatePropertyAll(buttonsColor),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: iconsAndTextsColor, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: iconsAndTextsColor, fontWeight: FontWeight.bold),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: menuColor
      ),
      listTileTheme: ListTileThemeData(textColor: iconsAndTextsColor, iconColor: iconsAndTextsColor)
  
    );
  }

}