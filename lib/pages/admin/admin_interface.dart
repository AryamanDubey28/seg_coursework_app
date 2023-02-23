import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/themes.dart';

// This widget is the root of the admin interface
class AdminInterface extends StatelessWidget {
  const AdminInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    final themeData = themeNotifier.getTheme();
    
    return MaterialApp(
      title: 'Admin Interface',
      theme: themeData,
      home: const AdminChoiceBoards(),
    );
  }
}
