import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/custom_theme_details.dart';
import 'package:seg_coursework_app/widgets/theme_grid.dart';

import '../../models/theme_details.dart';
import '../../themes/themes.dart';
import 'customize_theme_page.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {

  void updateThemeList(List<CustomThemeDetails> themeList, CustomTheme themeNotifier)
  {
    setState(() {
      themeList = themeNotifier.getThemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    final List<CustomThemeDetails> themeList = themeNotifier.getThemes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Themes"),
        leading: IconButton(
          key: const Key("backButton"),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: "Back",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomizeThemePage(themeList: themeList, updateThemeList: updateThemeList),
                ),
              );
            }, 
            tooltip: "Add a new theme",
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 500,
          child: ThemeGrid(themeList: themeList)
        )
      ),
    );
  }
}