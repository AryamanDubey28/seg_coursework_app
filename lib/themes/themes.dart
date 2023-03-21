import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';
import '../helpers/cache_manager.dart';

//Declarations of default themes.
final defaultTheme = CustomThemeDetails(
  name: "Default theme",
  menuColor: Colors.teal[300],
  backgroundColor: Colors.teal[100],
  buttonsColor: Colors.teal[400],
  iconsAndTextsColor: Colors.black,
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
  iconsAndTextsColor: Colors.black,
);

final deepOrangeTheme = CustomThemeDetails(
  name: "Orange theme",
  menuColor: Colors.deepOrange[300],
  backgroundColor: Colors.deepOrange[100],
  buttonsColor: Colors.deepOrange[400],
  iconsAndTextsColor: Colors.black,
);

///This class manages the default themes, the custom themes, and the cached theme.
class CustomTheme with ChangeNotifier {
  CustomThemeDetails? _cachedTheme;
  ThemeData _themeData = defaultTheme.getCustomThemeData();
  CustomThemeDetails _themeDetails = defaultTheme;

  CustomThemeDetails? get cachedTheme => _cachedTheme;

  CustomTheme() {
    loadCachedTheme();
  }

  ///Sets the cached theme as the app theme.
  Future<void> loadCachedTheme() async {
    _cachedTheme = await CacheManager.readCachedThemeDetails();
    if (_cachedTheme != null) {
      setTheme(_cachedTheme!);
      if (!themesListContainsTheme(_cachedTheme!)) {
        addTheme(_cachedTheme!);
      }
    }
  }

  ///Checks if the themesList contains the passed theme.
  bool themesListContainsTheme(CustomThemeDetails theme) {
    for (CustomThemeDetails e in _themesList) {
      if (e.equals(theme)) return true;
    }
    return false;
  }

  ThemeData getTheme() => _themeData;
  CustomThemeDetails getThemeDetails() => _themeDetails;

  List<CustomThemeDetails> _themesList = [
    defaultTheme,
    redTheme,
    deepPurpleTheme,
    lightGreenTheme,
    greenTheme,
    deepOrangeTheme
  ];
  List<CustomThemeDetails> getThemes() => _themesList;

  ///Adds the theme to the themesList if its not already in there.
  bool addTheme(CustomThemeDetails themeToAdd) {
    if (themesListContainsTheme(themeToAdd)) return false;
    _themesList.insert(1, themeToAdd);
    return true;
  }

  ///Changes the app theme to the passed theme.
  setTheme(CustomThemeDetails customThemeDetails) async {
    _themeData = customThemeDetails.getCustomThemeData();
    _themeDetails = customThemeDetails;
    notifyListeners();
    CacheManager.saveThemeDetailsToCache(customThemeDetails);
  }

}
