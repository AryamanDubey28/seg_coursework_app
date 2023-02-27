import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_theme_details.dart';
import '../themes/themes.dart';

class ThemeControls extends StatefulWidget {
  List<CustomThemeDetails> themeList;
  
  Function updateThemeList;

  Function setMenuColor;

  Function setBackgroundColor;

  Function setButtonsColor;

  Function setIconsAndTextsColor;

  ThemeControls({super.key, 
  required this.setMenuColor, 
  required this.setBackgroundColor, 
  required this.setButtonsColor, 
  required this.setIconsAndTextsColor, 
  required this.themeList, 
  required this.updateThemeList});

  @override
  State<ThemeControls> createState() => _ThemeControlsState();
}

class _ThemeControlsState extends State<ThemeControls> {
  Color? menuColor = Colors.teal[300];

  Color? backgroundColor = Colors.teal[100];

  Color? buttonsColor = Colors.teal[400];

  Color? iconsAndTextsColor = Colors.white;

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

  Future<dynamic> ShowIconsAndTextsColorChooserDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          actions: <Widget>[
            Container(
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

  TextButton BuildSaveButton(CustomTheme themeNotifier) {
    return TextButton(
      child: Text("Save"),
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
        widget.updateThemeList(widget.themeList, themeNotifier);
      
      })
    );
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
            title: Text("Menu color"),
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
        Container(
          width: 300,
          height: 60,
          child: ListTile(
            title: Text("Background color"),
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
              if (newBackgroundColor != null) {
                setState(() {
                  backgroundColor = newBackgroundColor;
                  widget.setBackgroundColor(newBackgroundColor);
                });
              }
            }
          ),
        ),
        Container(
          width: 300,
          height: 60,
          child: ListTile(
            title: Text("Buttons color"),
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
        Container(
          width: 300,
          height: 60,
          child: ListTile(
            title: Text("Icons and texts color"),
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.black, width: 2),
                color: iconsAndTextsColor,
              ),
            ),
            onTap: () {
              ShowIconsAndTextsColorChooserDialog(context).then((newIconsAndTextsColor) {
                if (newIconsAndTextsColor != null) {
                  // Do something with the selected color
                  // For example, update the state to rebuild the UI with the new color
                  setState(() {
                    iconsAndTextsColor = newIconsAndTextsColor;
                    widget.setIconsAndTextsColor(newIconsAndTextsColor);
                  });
                }
              });
            },
          ),
        ),
        BuildSaveButton(themeNotifier),
      ],
    );
  }
}