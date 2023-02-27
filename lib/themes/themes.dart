import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';
import 'package:seg_coursework_app/models/theme_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

final defaultTheme = CustomThemeDetails(
  name: "Default theme",
  menuColor: Colors.teal[300],
  backgroundColor: Colors.teal[100],
  buttonsColor: Colors.teal[400],
  iconsAndTextsColor: Colors.white,
);

final redTheme = CustomThemeDetails(
  name: "Red theme",
  menuColor: Colors.red[300],
  backgroundColor: Colors.red[100],
  buttonsColor: Colors.red[400],
  iconsAndTextsColor: Colors.white,
);

final deepPurpleTheme = CustomThemeDetails(
  name: "Purple theme",
  menuColor: Colors.deepPurple[300],
  backgroundColor: Colors.deepPurple[100],
  buttonsColor: Colors.deepPurple[400],
  iconsAndTextsColor: Colors.white,
);

final lightGreenTheme = CustomThemeDetails(
  name: "Light green theme",
  menuColor: Colors.lightGreen[300],
  backgroundColor: Colors.lightGreen[100],
  buttonsColor: Colors.lightGreen[400],
  iconsAndTextsColor: Colors.black,
);

final greenTheme = CustomThemeDetails(
  name: "Green theme",
  menuColor: Colors.green[300],
  backgroundColor: Colors.green[100],
  buttonsColor: Colors.green[400],
  iconsAndTextsColor: Colors.white,
);

final deepOrangeTheme = CustomThemeDetails(
  name: "Orange theme",
  menuColor: Colors.deepOrange[300],
  backgroundColor: Colors.deepOrange[100],
  buttonsColor: Colors.deepOrange[400],
  iconsAndTextsColor: Colors.white,
);

final darkTheme = ThemeDetails(name: "Dark theme", themeData: ThemeData.dark());



class CustomTheme with ChangeNotifier
{
  CustomThemeDetails? _cachedTheme;
  ThemeData _themeData = defaultTheme.getCustomTheme().themeData;
  CustomThemeDetails _themeDetails = defaultTheme;

  CustomThemeDetails? get cachedTheme => _cachedTheme;

  CustomTheme() {
    loadCachedTheme();
  }

  Future<void> loadCachedTheme() async {
    _cachedTheme = await readCachedThemeDetails();
    if (_cachedTheme != null) {
      setTheme(_cachedTheme!);
      if(!themesListContainsTheme(_cachedTheme!))
      {
        addTheme(_cachedTheme!);
      }
    }
  }

  bool themesListContainsTheme(CustomThemeDetails element) {
    for (CustomThemeDetails e in _themesList) {
      if (e.equals(element)) return true;
    }
    return false;
  }

  ThemeData getTheme() => _themeData;
  CustomThemeDetails getThemeDetails() => _themeDetails;

  List<CustomThemeDetails> _themesList = [defaultTheme, redTheme, deepPurpleTheme, lightGreenTheme, greenTheme, deepOrangeTheme];
  List<CustomThemeDetails> getThemes() => _themesList;

  bool addTheme(CustomThemeDetails themeToAdd)
  {
    if(themesListContainsTheme(themeToAdd)) return false;
    _themesList.add(themeToAdd);
    return true;
  }

  setTheme(CustomThemeDetails customThemeDetails) async
  {
    _themeData = customThemeDetails.getCustomTheme().themeData;
    _themeDetails = customThemeDetails;
    notifyListeners();
    saveThemeDetailsToCache(customThemeDetails);
  }

  static Future<CustomThemeDetails?> readCachedThemeDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? themeString = prefs.getString('cached_theme');
  if (themeString != null) {
    Map<String, dynamic> jsonMap = json.decode(themeString);
    CustomThemeDetails temp = CustomThemeDetails(
      name: jsonMap['name'],
      menuColor: Color(jsonMap['menuColor']),
      backgroundColor: Color(jsonMap['backgroundColor']),
      buttonsColor: Color(jsonMap['buttonsColor']),
      iconsAndTextsColor: Color(jsonMap['iconsAndTextsColor']),);
    return temp;
  }
  return null;
  }

  Future<void> saveThemeDetailsToCache(CustomThemeDetails customThemeDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonMap = {
      'name': customThemeDetails.name,
      'menuColor': customThemeDetails.menuColor!.value,
      'backgroundColor': customThemeDetails.backgroundColor!.value,
      'buttonsColor': customThemeDetails.buttonsColor!.value,
      'iconsAndTextsColor': customThemeDetails.iconsAndTextsColor!.value,
    };
    prefs.setString('cached_theme', json.encode(jsonMap));
  }
}