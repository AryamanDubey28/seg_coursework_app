import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';
import '../../../widgets/theme/mock_app_theme_preview.dart';
import '../../../widgets/theme/theme_controls.dart';

class CustomizeThemePage extends StatefulWidget {
  const CustomizeThemePage(
      {super.key, required this.themeList, required this.updateThemeList});

  final List<CustomThemeDetails> themeList;
  final Function updateThemeList;

  @override
  State<CustomizeThemePage> createState() => _CustomizeThemePageState();
}

/// The page for the user to manipulate theme colors and preview changes.
class _CustomizeThemePageState extends State<CustomizeThemePage> {
  Color? menuColor = Colors.teal[300];

  Color? backgroundColor = Colors.teal[100];

  Color? buttonsColor = Colors.teal[400];

  Color? iconsAndTextsColor = Colors.white;

  ///A function that is fed to and used by the theme controls to set the menu color.
  void setMenuColor(Color? newMenuColor) {
    setState(() {
      menuColor = newMenuColor;
    });
  }

  ///A function that is fed to and used by the theme controls to set the background color.
  void setBackgroundColor(Color? newBackgroundColor) {
    setState(() {
      backgroundColor = newBackgroundColor;
    });
  }

  ///A function that is fed to and used by the theme controls to set the buttons color.
  void setButtonsColor(Color? newButtonsColor) {
    setState(() {
      buttonsColor = newButtonsColor;
    });
  }

  ///A function that is fed to and used by the theme controls to set the icons and texts color.
  void setIconsAndTextsColor(Color? newIconsAndTextsColor) {
    setState(() {
      iconsAndTextsColor = newIconsAndTextsColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize Theme"),
        leading: IconButton(
            key: const Key("backButton"),
            tooltip: "Back",
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ThemeControls(
                  setMenuColor: setMenuColor,
                  setBackgroundColor: setBackgroundColor,
                  setButtonsColor: setButtonsColor,
                  setIconsAndTextsColor: setIconsAndTextsColor,
                  themeList: widget.themeList,
                  updateThemeList: widget.updateThemeList),
            ),
            Expanded(
              child: MockAppThemePreview(
                  backgroundColor: backgroundColor,
                  iconsAndTextsColor: iconsAndTextsColor,
                  menuColor: menuColor,
                  buttonsColor: buttonsColor),
            )
          ],
        ),
      ),
    );
  }
}
