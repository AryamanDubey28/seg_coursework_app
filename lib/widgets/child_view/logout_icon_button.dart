import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/admin/choice_board/admin_choice_boards.dart';
import '../../services/auth.dart';

class LogoutIconButton extends StatelessWidget {
  TextEditingController pinController;
  late Auth authenticationHelper;
  bool mock;
  LogoutIconButton(
      {required this.pinController,
      required this.authenticationHelper,
      this.mock = false,
      super.key}) {
    pinController = pinController;
    authenticationHelper = authenticationHelper;
  }

  /// Opens a dialog with a text field to enter a PIN
  /// that pops up when the user holds the logout button
  Future openLogoutDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Enter your PIN to go back to the Admin Home"),
            content: TextField(
              key: const Key("logoutButtonTextField"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              controller: pinController,
            ),
            actions: [
              TextButton(
                  key: const Key("submitButton"),
                  onPressed: () => submitPin(context),
                  child: const Text("SUBMIT"))
            ],
          ));

  /// verify password is correct, if so then navigates back.
  /// otherwise show error message
  Future<void> submitPin(BuildContext context) async {
    String currentPin = await authenticationHelper.getCurrentUserPIN();
    if (pinController.text.trim() == currentPin) {
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
            return const AlertDialog(
              content: Text(
                "Incorrect PIN Provided",
                textAlign: TextAlign.center,
              ),
            );
          });
    }
    pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: const Key("logoutButton"),
        onLongPress: () async {
          openLogoutDialog(context);
        },
        onTap: () async {
          if (mock) {
            openLogoutDialog(context);
          }
        },
        child: const Icon(Icons.exit_to_app));
  }
}
