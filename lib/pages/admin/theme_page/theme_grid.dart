import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/admin_timetable/theme_grid_square.dart';

/// This widget is the whole theme page and it shows a choice board of all the themes that are fed into it.
class ThemeGrid extends StatelessWidget {
  const ThemeGrid({super.key, required this.themeList});

  final List<CustomThemeDetails> themeList;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);

    return GridView.builder(
        itemCount: themeList.length,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
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
              child: ThemeGridSquare(
                  key: Key('themeSquare$index'),
                  themeDetails: themeList[index]),
            ),
          );
        });
  }
}
