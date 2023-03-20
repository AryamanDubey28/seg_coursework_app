import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/custom_theme_details.dart';
import '../../themes/themes.dart';

class ThemeControls extends StatefulWidget {
  final List<CustomThemeDetails> themeList;
  
  final Function updateThemeList;

  final Function setMenuColor;

  final Function setBackgroundColor;

  final Function setButtonsColor;

  final Function setIconsAndTextsColor;

  const ThemeControls({super.key, 
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
    if(isAdded)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Theme saved successfully.")
        ),
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Theme is already saved.")
        ),
      );
    }
  }

  ///A dialog that allows the user to choose between the colors black and white.
  Future<dynamic> ShowIconsAndTextsColorChooserDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          actions: <Widget>[
            Container(
              key: const Key("blackButton"),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
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
              key: const Key("whiteButton"),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                // Set the color to white and close the dialog
                Navigator.of(context).pop(Colors.white);
                },
              ),
            ),
          ]
        );
      },
    );
  }

  ///A text button that saves the current theme settings.
  TextButton buildSaveButton(CustomTheme themeNotifier) {
    return TextButton(
      key: const Key("saveButton"),
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
      child: const Text("Save")
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 300,
          height: 60,
          child: ListTile(
            key: const Key("menuColorListTile"),
            title: const Text("Menu color"),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
                color: menuColor,
              ),
            ),
            onTap: () async {
              Color newMenuColor = await showColorPickerDialog(
                context, 
                menuColor!
              );
              if (newMenuColor != null) {
                setState(() {
                  menuColor = newMenuColor;
                  widget.setMenuColor(newMenuColor);
                });
              }
            }
          ),
        ),
        SizedBox(
          width: 300,
          height: 60,
          child: ListTile(
            key: const Key("backgroundColorListTile"),
            title: const Text("Background color"),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
                color: backgroundColor,
              ),
            ),
            onTap: () async {
              Color newBackgroundColor = await showColorPickerDialog(
                context, 
                backgroundColor!
              );
              setState(() {
                backgroundColor = newBackgroundColor;
                widget.setBackgroundColor(newBackgroundColor);
              });
            }
          ),
        ),
        SizedBox(
          width: 300,
          height: 60,
          child: ListTile(
            key: const Key("buttonsColorListTile"),
            title: const Text("Buttons color"),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
                color: buttonsColor,
              ),
            ),
            onTap: () async {
              Color newButtonsColor = await showColorPickerDialog(
                context, 
                buttonsColor!
              );
              if (newButtonsColor != null) {
                setState(() {
                  buttonsColor = newButtonsColor;
                  widget.setButtonsColor(newButtonsColor);
                });
              }
            }
          ),
        ),
        SizedBox(
          width: 300,
          height: 60,
          child: ListTile(
            key: const Key("iconsAndTextsColorListTile"),
            title: const Text("Icons and texts color"),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
                color: iconsAndTextsColor,
              ),
            ),
            onTap: () {
              //(then) is used to take the color chosen from the dialog.
              ShowIconsAndTextsColorChooserDialog(context).then((newIconsAndTextsColor) {
                setState(() {
                  //null safety in case user doesn't pick a color.
                  if(newIconsAndTextsColor != null)
                  {
                    iconsAndTextsColor = newIconsAndTextsColor;
                    widget.setIconsAndTextsColor(newIconsAndTextsColor);
                  }
                  else
                  {
                    iconsAndTextsColor = Colors.white;
                    widget.setIconsAndTextsColor(Colors.white);
                  }
                });
              });
            },
          ),
        ),
        buildSaveButton(themeNotifier),
      ],
    );
  }
}