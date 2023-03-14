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
  //final auth = Auth(auth: FirebaseAuth.instance);

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
            return isInChildMode
                ? CustomizableColumn()
                : AdminChoiceBoards(
                    draggableCategories: devCategories,
                  );
          } else {
            //snapshot does not contain user data therefore, not logged in
            return const ToggleAuth();
          }
        },
      ),
    );
  }
}
