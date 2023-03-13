import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'toggleAuth.dart';

class Wrapper extends StatelessWidget {
  final bool isInChildMode;

  Wrapper({Key? key, required this.isInChildMode}) : super(key: key);

  Stream<User?> get user => FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if we are trying to sign in and snapshot contains user data, we are logged in
            return isInChildMode ? CustomizableColumn() : AdminChoiceBoards();
          } else {
            //snapshot does not contain user data therefore, not logged in
            return const ToggleAuth();
          }
        },
      ),
    );
  }
}
