import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/custom_theme_details.dart';
import '../../themes/themes.dart';

class ThemeControls extends StatefulWidget {
  List<CustomThemeDetails> themeList;

  Function updateThemeList;

  Function setMenuColor;

  Function setBackgroundColor;

  Function setButtonsColor;

  Function setIconsAndTextsColor;

  ThemeControls(
      {super.key,
      required this.setMenuColor,
      required this.setBackgroundColor,
      required this.setButtonsColor,
      required this.setIconsAndTextsColor,
      required this.themeList,
      required this.updateThemeList});

  @override
  State<ThemeControls> createState() => _ThemeControlsState();
}

/// The widget for the admin to manipulate the theme colors.
class _ThemeControlsState extends State<ThemeControls> {
  Color? menuColor = Colors.teal[300];

  Color? backgroundColor = Colors.teal[100];

  Color? buttonsColor = Colors.teal[400];

  Color? iconsAndTextsColor = Colors.white;

  ///Shows a message depending on if a theme is already saved or not.
  void showSnackBarMessage(bool isAdded) {
    if (isAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Theme saved successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Theme is already saved.")),
      );
    }
  }

  ///A dialog that allows the user to choose between the colors black and white.
  Future<dynamic> ShowIconsAndTextsColorChooserDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text('Select a color'), actions: <Widget>[
          Container(
            key: Key("blackButton"),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: Colors.black,
            ),
            child: GestureDetector(
              onTap: () {
                // Set the color to black and close the dialog
                Navigator.of(context).pop(Colors.black);
              },
            ),
          ),
          Container(
            key: Key("whiteButton"),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                // Set the color to white and close the dialog
                Navigator.of(context).pop(Colors.white);
              },
            ),
          ),
        ]);
      },
    );
  }

  ///A text button that saves the current theme settings.
  TextButton BuildSaveButton(CustomTheme themeNotifier) {
    return TextButton(
        key: Key("saveButton"),
        onPressed: () => setState(() {
              CustomThemeDetails temp = CustomThemeDetails(
                name: "Custom theme",
                menuColor: menuColor,
                backgroundColor: backgroundColor,
                buttonsColor: buttonsColor,
                iconsAndTextsColor: iconsAndTextsColor,
              );
              bool isAdded = themeNotifier.addTheme(temp);
              showSnackBarMessage(isAdded);
              themeNotifier.setTheme(temp);
              widget.updateThemeList(widget.themeList, themeNotifier);
            }),
        child: Text("Save"));
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          height: 60,
          child: ListTile(
              key: Key("menuColorListTile"),
              title: Text("Menu color"),
              trailing: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: menuColor,
                ),
              ),
              onTap: () async {
                Color newMenuColor =
                    await showColorPickerDialog(context, menuColor!);
                if (newMenuColor != null) {
                  setState(() {
                    menuColor = newMenuColor;
                    widget.setMenuColor(newMenuColor);
                  });
                }
              }),
        ),
        Container(
          width: 300,
          height: 60,
          child: ListTile(
              key: Key("backgroundColorListTile"),
              title: Text("Background color"),
              trailing: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: backgroundColor,
                ),
              ),
              onTap: () async {
                Color newBackgroundColor =
                    await showColorPickerDialog(context, backgroundColor!);
                if (newBackgroundColor != null) {
                  setState(() {
                    backgroundColor = newBackgroundColor;
                    widget.setBackgroundColor(newBackgroundColor);
                  });
                }
              }),
        ),
        Container(
          width: 300,
          height: 60,
          child: ListTile(
              key: Key("buttonsColorListTile"),
              title: Text("Buttons color"),
              trailing: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: buttonsColor,
                ),
              ),
              onTap: () async {
                Color newButtonsColor =
                    await showColorPickerDialog(context, buttonsColor!);
                if (newButtonsColor != null) {
                  setState(() {
                    buttonsColor = newButtonsColor;
                    widget.setButtonsColor(newButtonsColor);
                  });
                }
              }),
        ),
        Container(
          width: 300,
          height: 60,
          child: ListTile(
            key: Key("iconsAndTextsColorListTile"),
            title: Text("Icons and texts color"),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                color: iconsAndTextsColor,
              ),
            ),
            onTap: () {
              //(then) is used to take the color chosen from the dialog.
              ShowIconsAndTextsColorChooserDialog(context)
                  .then((newIconsAndTextsColor) {
                setState(() {
                  //null safety in case user doesn't pick a color.
                  if (newIconsAndTextsColor != null) {
                    iconsAndTextsColor = newIconsAndTextsColor;
                    widget.setIconsAndTextsColor(newIconsAndTextsColor);
                  } else {
                    iconsAndTextsColor = Colors.white;
                    widget.setIconsAndTextsColor(Colors.white);
                  }
                });
              });
            },
          ),
        ),
        BuildSaveButton(themeNotifier),
      ],
    );
  }
}
