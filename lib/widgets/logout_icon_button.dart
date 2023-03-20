import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/admin/admin_choice_boards.dart';
import '../services/auth.dart';

class LogoutIconButton extends StatelessWidget {
  TextEditingController pin_controller;
  late Auth authenticationHelper;
  bool mock;
  Key key;
  LogoutIconButton(
      {required this.pin_controller,
      required this.authenticationHelper,
      this.mock = false,
      required this.key}) {
    this.pin_controller = pin_controller;
    this.authenticationHelper = authenticationHelper;
  }

  Future openLogoutDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Enter your PIN to go back to the Admin Home"),
            content: TextField(
              key: Key("logoutButtonTextField"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              controller: pin_controller,
            ),
            actions: [
              TextButton(
                  key: Key("submitButton"),
                  onPressed: () => submitPin(context),
                  child: Text("SUBMIT"))
            ],
          ));

  Future<void> submitPin(BuildContext context) async {
    //verifys password is correct, if so then navigates back. otherwise says incorrect
    String currentPin = await authenticationHelper.getCurrentUserPIN();

    if (pin_controller.text.trim() == currentPin) {
      // final pref = await SharedPreferences.getInstance();
      // pref.setBool("isInChildMode",
      //     false); //isInChildMode boolean set to false as we are leaving
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AdminChoiceBoards(
                  mock: mock,
                  auth: authenticationHelper.auth,
                  firestore: authenticationHelper.firestore,
                  storage: mock ? MockFirebaseStorage() : null,
                ),
            maintainState: false),
      );
      final pref = await SharedPreferences.getInstance();
      pref.setBool("isInChildMode", false);
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Incorrect PIN Provided",
                textAlign: TextAlign.center,
              ),
            );
          });
    }
    pin_controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: Key("logoutButton"),
        onLongPress: () async {
          openLogoutDialog(context);
        },
        onTap: () async {
          if (mock) {
            openLogoutDialog(context); //widget tester can only tap
          }
        },
        child: Icon(Icons.exit_to_app));
  }
}
