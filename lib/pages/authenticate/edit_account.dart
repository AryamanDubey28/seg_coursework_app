import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/my_text_field.dart';
import '../admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import '../admin/admin_side_menu.dart';
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

  @override
  void initState() {
    super.initState();
    authentitcationHelper = Auth(auth: FirebaseAuth.instance);
  }

  void show_alert_dialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              text,
              style: TextStyle(fontSize: 24),
            ),
          );
        });
  }

  Future commit_password_edit() async {
    String response;
    if (_currentPasswordController.text.trim() != "" &&
        _newPasswordController.text.trim() != "" &&
        _confirmPasswordController.text.trim() != "") {
      if (_newPasswordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        LoadingIndicatorDialog().show(context);
        response = await authentitcationHelper.editCurrentUserPassword(
            _currentPasswordController.text.trim(),
            _newPasswordController.text.trim());
        LoadingIndicatorDialog().dismiss();
      } else {
        response =
            'The new password confirmation does not match the new password you demanded. Please try again.';
      }
    } else {
      response =
          'Some fields required to operate your password change were not filled in. Please try again.';
    }
    show_alert_dialog(response);
  }

  Future commit_email_edit() async {
    String response;
    if (_emailEditController.text.trim() != "" &&
        authentitcationHelper.validEmail(_emailEditController.text.trim())) {
      LoadingIndicatorDialog().show(context);
      response = await authentitcationHelper
          .editCurrentUserEmail(_emailEditController.text.trim());
      LoadingIndicatorDialog().dismiss();
    } else {
      response =
          'You did not input a valid email address so the change could not be made. Please try again.';
    }
    show_alert_dialog(response);
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
                            key: const Key("edit_email_prompt"),
                            child: Text("Edit your email:",
                                style: TextStyle(
                                  fontSize: 30,
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MyTextField(
                            key: Key('email_text_field'),
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
                                key: Key('edit_email_submit'),
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
                              key: Key('edit_password_prompt'),
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
                            key: Key('confirm_new_password_input'),
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
                                key: Key('edit_password_submit'),
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
