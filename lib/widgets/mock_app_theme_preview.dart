import 'package:flutter/material.dart';

class MockAppThemePreview extends StatelessWidget {
  const MockAppThemePreview({
    super.key,
    required this.menuColor,
    required this.backgroundColor,
    required this.buttonsColor,
    required this.iconsAndTextsColor,
  });

  final Color? menuColor;
  final Color? backgroundColor;
  final Color? buttonsColor;
  final Color? iconsAndTextsColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
    );
  }
}