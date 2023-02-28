import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

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
      // routes: {
      //   // When navigating to the "homeScreen" route, build the HomeScreen widget.
      //   'homeScreen': (context) => AdminChoiceBoards(),
      //   // add another route by: 'name' : (context) => PageName()
      // },
      // initialRoute: 'homeScreen',
      home: const AdminChoiceBoards(),
    );
  }
}
