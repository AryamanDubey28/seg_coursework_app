import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin_choice_boards.dart';

// This widget is the root of the admin interface
class AdminInterface extends StatelessWidget {
  const AdminInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Interface',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AdminChoiceBoards(),
    );
  }
}
