import 'package:flutter/material.dart';
import 'admin_side_menu.dart';

// The page for admins to edit choice boards
class AdminChoiceBoards extends StatelessWidget {
  const AdminChoiceBoards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Choice Boards'),
        ),
        drawer: const AdminSideMenu(),
      );
}
