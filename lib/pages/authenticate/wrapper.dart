import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/child/child_main_menu.dart';
import 'toggleAuth.dart';

class Wrapper extends StatelessWidget {
  final bool isInChildMode;
  late final FirebaseAuth auth;

  Wrapper({Key? key, FirebaseAuth? auth, required this.isInChildMode})
      : super(key: key) {
    this.auth = auth ?? FirebaseAuth.instance;
  }

  Stream<User?> get user => auth.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if we are trying to sign in and snapshot contains user data, we are logged in
            return isInChildMode ? ChildMainMenu() : AdminChoiceBoards();
          } else {
            //snapshot does not contain user data therefore, not logged in
            return ToggleAuth(auth: auth);
          }
        },
      ),
    );
  }
}
