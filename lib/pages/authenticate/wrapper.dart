import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'toggleAuth.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';

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
            //if we are trying to sign in and snapshot contains user data, we are logged in
            return isInChildMode
                ? CustomizableColumn()
                : AdminChoiceBoards(
                    draggableCategories: devCategories,
                  );
          } else {
            //snapshot does not contain user data therefore, not logged in
            return ToggleAuth(auth: auth);
          }
        },
      ),
    );
  }
}
