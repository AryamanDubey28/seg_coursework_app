import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

class ThemeProvider extends StatelessWidget {
  final CustomTheme themeNotifier;
  final Widget child;

  ThemeProvider({required this.themeNotifier, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomTheme>(
      create: (_) => themeNotifier,
      child: child,
    );
  }
}