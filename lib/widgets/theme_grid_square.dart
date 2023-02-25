import 'package:flutter/material.dart';

import '../models/theme_details.dart';

class ThemeGridSquare extends StatelessWidget {
  const ThemeGridSquare({
    super.key,
    required this.themeDetails,
  });

  final ThemeDetails themeDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black, width: 2),
          color: themeDetails.themeData.scaffoldBackgroundColor,
          ),
          padding: EdgeInsets.all(8),
          width: 150,
          height: 150,
          
          
        ),
        SizedBox(height: 10,),
        Text(themeDetails.name)
      ],
    );
  }
}