import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/child_board.dart';

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
      home: const ChildBoards(),
    );
  }
}
