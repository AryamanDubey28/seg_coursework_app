import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/theme_details.dart';
import 'package:seg_coursework_app/themes/themes.dart';

/// This widget is the bottom half of the visual timetable interface 
/// and it shows a choice board of all the images that are fed into it.
class ThemeGrid extends StatelessWidget {
  const ThemeGrid({super.key});

  

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    final List<ThemeDetails> themeList = themeNotifier.getThemes();

    return GridView.builder(
      itemCount: themeList.length,
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            themeNotifier.setTheme(themeList[index]);
          },
          child: Tooltip(
            message: themeList[index].name,
            child: Container(
              decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black, width: 2),
              color: themeList[index].themeData.scaffoldBackgroundColor,
              ),
              padding: EdgeInsets.all(8),
              width: 150,
              height: 150,
              key: Key('theme$index'),
              
            ),
          ),
        );
      }
    );
  }
}