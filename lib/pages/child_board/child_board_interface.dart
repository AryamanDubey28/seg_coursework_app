import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'child_board.dart';

// Create pages for all the menu items

// This widget is the root of the child board
class ChildInterface extends StatelessWidget {
  const ChildInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child Interface',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        // When navigating to the "homeScreen" route, build the HomeScreen widget.
        'homeScreen': (context) => ChildBoards(),
        'adminScreen': (context) => AdminChoiceBoards(),
        // add another route by: 'name' : (context) => PageName()
      },
      initialRoute: 'homeScreen',
      home: const ChildBoards(),
    );
  }
}
