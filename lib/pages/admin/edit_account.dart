import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/my_text_field.dart';
import 'admin_choice_boards.dart';
import '../authenticate/auth.dart';
import './admin_side_menu.dart';

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

  Future commit_changes() async {
    if (_emailEditController.text.trim() != "") {
      User? firebaseUser = await firebaseAuthentication.currentUser;
      if (firebaseUser != null) {
        var message;
        try {
          await firebaseUser.updateEmail(_emailEditController.text.trim());
          print("EMAIL - SUCCESS");
        } on FirebaseAuthException catch (e) {
          print("EMAIL - LOG IN AGAIN");
          print(e.message);
        } catch (e) {
          print("EMAIL - LOG IN AGAIN");
          rethrow;
        }
      }
    } else if (_currentPasswordController.text.trim() != "" &&
        _newPasswordController.text.trim() != "" &&
        _confirmPasswordController.text.trim() != "") {
      print("UPDATING PWD");
      if (_newPasswordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        User? firebaseUser = await firebaseAuthentication.currentUser;
        if (firebaseUser != null) {
          try {
            var credentials = EmailAuthProvider.credential(
                email: await authentitcationHelper.getCurrentUserEmail(),
                password: _currentPasswordController.text.trim());
            await firebaseUser
                .reauthenticateWithCredential(credentials)
                .then((value) {
              firebaseUser.updatePassword(_newPasswordController.text.trim());
            });
            print("PWD - SUCCESS");
          } on FirebaseAuthException catch (e) {
            print("PWD - LOGIN AGAIN OR PASSWORD INCORRECT");
          } catch (e) {
            print("PWD - TRUC CHELOU");
            rethrow;
          }
        }
      } else {
        // confirmation different from other
      }
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
                                onPressed: commit_changes,
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
                                onPressed: commit_changes,
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
