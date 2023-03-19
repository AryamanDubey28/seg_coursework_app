
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';

///The widget to show a single theme square on the theme grid.
class ThemeGridSquare extends StatelessWidget {
  const ThemeGridSquare({
    super.key,
    required this.themeDetails,
  });

  final CustomThemeDetails themeDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          width: 150,
          height: 150,
          decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black, width: 2),
          color: themeDetails.getCustomThemeData().scaffoldBackgroundColor,
          ),
        ),
        SizedBox(height: 10,),
        Text(themeDetails.name)
      ],
    );
  }
}