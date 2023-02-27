import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';
import 'package:seg_coursework_app/models/theme_details.dart';

import '../../themes/themes.dart';

class CustomizeThemePage extends StatefulWidget {
  const CustomizeThemePage({super.key, required List<CustomThemeDetails> this.themeList, required void Function(List<CustomThemeDetails> themeList, CustomTheme themeNotifier) this.updateThemeList});

  final List<CustomThemeDetails> themeList;
  final Function updateThemeList;
  @override
  State<CustomizeThemePage> createState() => _CustomizeThemePageState();
}

class _CustomizeThemePageState extends State<CustomizeThemePage> {
  Color? menuColor = Colors.teal[300];
  Color? backgroundColor = Colors.teal[100];
  Color? buttonsColor = Colors.teal[400];
  Color? iconsAndTextsColor = Colors.white;


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Theme"),
        leading: IconButton(
          key: const Key("backButton"),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
      ),

      body: Center(
        child: Row(
          children: [
            Expanded(
              child: Column(
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
                        showDialog(
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
                                    // Set the color to black and close the dialog
                                    Navigator.of(context).pop(Colors.white);
                                    },
                                  ),
                                ),
                              ]
                            );
                          },
                        ).then((selectedColor) {
                          if (selectedColor != null) {
                            // Do something with the selected color
                            // For example, update the state to rebuild the UI with the new color
                            setState(() {
                              iconsAndTextsColor = selectedColor;
                            });
                          }
                        });
                      },
                    ),
                  ),
                  TextButton(
                    child: Text("Save"),
                    onPressed: () => setState(() {
                      CustomThemeDetails temp = CustomThemeDetails(
                        name: "Custom theme", 
                        menuColor: menuColor, 
                        backgroundColor: backgroundColor, 
                        buttonsColor: buttonsColor, 
                        iconsAndTextsColor: iconsAndTextsColor,
                      );
                      themeNotifier.addTheme(temp);
                      widget.updateThemeList(widget.themeList, themeNotifier);
                    
                    })
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: iconsAndTextsColor,), 
                        onPressed: () {},
                      ),
                      backgroundColor: menuColor,
                      elevation: 0,
                      title: Text(
                        'Menu',
                        style: TextStyle(color: iconsAndTextsColor)
                        // themeData.primaryTextTheme.headline6,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: [
                        FloatingActionButton(
                          elevation: 0,
                          backgroundColor: buttonsColor,
                          onPressed: () {},
                          child: Icon(
                            Icons.add,
                            color: iconsAndTextsColor,
                            // color: themeData.accentIconTheme.color,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Example Text',
                          style: TextStyle(color: iconsAndTextsColor),
                          // style: themeData.textTheme.headline6,
                        ),
                      ],
                    ),
                    SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}