import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/my_text_field.dart';
import 'admin_choice_boards.dart';
import '../authenticate/auth.dart';
import './admin_side_menu.dart';
import '../../widgets/loading_indicator.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({
    super.key,
  });

  @override
  State<EditAccountPage> createState() => EditAccountPageState();
}

class EditAccountPageState extends State<EditAccountPage> {
  final _emailEditController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final Auth authentitcationHelper;
  late final FirebaseAuth firebaseAuthentication;

  @override
  void initState() {
    super.initState();
    firebaseAuthentication = FirebaseAuth.instance;
    authentitcationHelper = Auth(auth: firebaseAuthentication);
  }

  void show_alert_dialog(String text, String key) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            key: Key(key),
            content: Text(
              text,
              style: TextStyle(fontSize: 24),
            ),
          );
        });
  }

  Future commit_password_edit() async {
    if (_currentPasswordController.text.trim() != "" &&
        _newPasswordController.text.trim() != "" &&
        _confirmPasswordController.text.trim() != "") {
      if (_newPasswordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        User? firebaseUser = await firebaseAuthentication.currentUser;
        if (firebaseUser != null) {
          try {
            LoadingIndicatorDialog().show(context);
            var credentials = EmailAuthProvider.credential(
                email: await authentitcationHelper.getCurrentUserEmail(),
                password: _currentPasswordController.text.trim());
            await firebaseUser
                .reauthenticateWithCredential(credentials)
                .then((value) {
              firebaseUser.updatePassword(_newPasswordController.text.trim());
            });
            LoadingIndicatorDialog().dismiss();
            show_alert_dialog("Your password was successfully changed.",
                "password_changed_successfully");
          } on FirebaseAuthException catch (e) {
            LoadingIndicatorDialog().dismiss();
            show_alert_dialog(
                'Your current password is not correct. Please try again.',
                'password_change_failure_incorrect_password');
          } catch (e) {
            LoadingIndicatorDialog().dismiss();
            show_alert_dialog(
                'We are sorry, we could not change your password. Please try again.',
                'password_change_failure_unknown_reason');
          }
        }
      } else {
        show_alert_dialog(
            'The new password confirmation does not match the new password you demanded. Please try again.',
            'password_change_failure_incorrect_confirmation');
      }
    } else {
      show_alert_dialog(
          'Some fields required to operate your password change were not filled in. Please try again.',
          'password_change_failure_missing_field');
    }
  }

  Future commit_email_edit() async {
    if (_emailEditController.text.trim() != "") {
      User? firebaseUser = await firebaseAuthentication.currentUser;
      if (firebaseUser != null) {
        var message;
        try {
          LoadingIndicatorDialog().show(context);
          await firebaseUser.updateEmail(_emailEditController.text.trim());
          LoadingIndicatorDialog().dismiss();
          show_alert_dialog('Your email was successfully changed.',
              'email_changed_successfully');
        } on FirebaseAuthException catch (e) {
          LoadingIndicatorDialog().dismiss();
          show_alert_dialog(
              'We could not securely verify your identity because you did not login for a long time. Please log out and back in to carry out this change.',
              'email_change_failure_login_too_old');
        } catch (e) {
          LoadingIndicatorDialog().dismiss();
          show_alert_dialog(
              'We could not securely verify your identity because you did not login for a long time. Please log out and back in to carry out this change.',
              'email_change_failure_login_too_old');
        }
      }
    } else {
      show_alert_dialog(
          'You did not input a new email address so the change could not be made. Please try again.',
          'email_change_failure_missing_field');
    }
  }

  @override
  void dispose() {
    _emailEditController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        key: Key('app_bar'),
        title: const Text('Edit Account'),
      ),
      drawer: const AdminSideMenu(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 1000,
              child: FutureBuilder<String>(
                future: authentitcationHelper.getCurrentUserEmail(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<String> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Edit your email:",
                                style: TextStyle(
                                  fontSize: 30,
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MyTextField(
                            key: Key('change_email_field'),
                            hint: snapshot.data as String,
                            controller: _emailEditController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 60,
                              width: 250,
                              child: ElevatedButton(
                                key: Key('confirm button'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.teal[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: commit_email_edit,
                                child: Text("Change Email"),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Edit your password:",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MyTextField(
                            key: Key('current_password_input'),
                            hint: "Current password",
                            controller: _currentPasswordController,
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MyTextField(
                            key: Key('new_password_input'),
                            hint: "New password",
                            controller: _newPasswordController,
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MyTextField(
                            key: Key('confirm_new_password'),
                            hint: "Password confirmation",
                            controller: _confirmPasswordController,
                            isPassword: true,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 60,
                              width: 250,
                              child: ElevatedButton(
                                key: Key('confirm button'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.teal[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: commit_password_edit,
                                child: Text("Change Password"),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
