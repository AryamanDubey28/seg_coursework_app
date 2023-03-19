import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/child/child_menu.dart';
import 'toggleAuth.dart';

// This class supports the logging in infrastructure by handling the reactions to a user's action to login
// or to log out and showing LogIn to users that are not yet logged in and AdminChoiceBoard or ChildBoard
// to the users that are.
class Wrapper extends StatelessWidget {
  final bool isInChildMode;
  late FirebaseAuth auth;

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
            // If we are trying to sign in and snapshot contains user data, we are logged in
            return isInChildMode ? ChildMenu() : AdminChoiceBoard();
          } else {
            // Snapshot does not contain user data therefore, not logged in
            return ToggleAuth(auth: auth);
          }
        },
      ),
    );
  }
}
