import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/theme_grid.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Themes"),
        leading: IconButton(
          key: const Key("backButton"),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: 500,
          child: ThemeGrid()
        )
      ),
    );
  }
}