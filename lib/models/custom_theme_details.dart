import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/theme_details.dart';

extension ColorExtension on Color {
  Color withoutAlpha() {
    return Color.fromRGBO(red, green, blue, 1);
  }
}

///This model allows for easy handling of the themes. It saves a name and a ThemeData for each theme.
class CustomThemeDetails {
  final String name;
  final Color? menuColor;
  final Color? backgroundColor;
  final Color? buttonsColor;
  final Color? iconsAndTextsColor;

  CustomThemeDetails({this.name = "Custom theme", this.menuColor = Colors.transparent, this.backgroundColor = Colors.transparent, this.buttonsColor = Colors.transparent, this.iconsAndTextsColor = Colors.transparent});

    MaterialColor getColorSwatch(Color color) {
    if (color is MaterialColor) {
      return color;
    } else {
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

  ThemeDetails getCustomTheme()
  {
    
    IconThemeData iconTheme = IconThemeData(
      color: iconsAndTextsColor,
    );
    return ThemeDetails(name: "Custom theme", 
    themeData: ThemeData(
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
  
    ));
  }

}