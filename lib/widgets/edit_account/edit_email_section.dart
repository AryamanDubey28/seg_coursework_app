import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';
import 'package:seg_coursework_app/widgets/general/my_text_field.dart';
import 'dart:async';
import '../../services/auth.dart';
import '../loading_indicators/loading_indicator.dart';

/// This widget returns all the components and functionalitlies necessary for the user to change their email.
class EditEmailSection extends StatelessWidget {
  late final BuildContext context;
  final _emailEditController = TextEditingController();
  late final Auth authentitcationHelper;
  late FirebaseAuth auth;
  late bool isTestMode;
  late FirebaseFirestore firebaseFirestore;

  EditEmailSection(
      {super.key,
      required this.authentitcationHelper,
      required this.isTestMode,
      required this.auth,
      required this.firebaseFirestore});

  // Verify the validity of fields and execute the change of a user's email.
  Future commitEmailEdit() async {
    String response;
    if (_emailEditController.text.trim() != "" &&
        authentitcationHelper.validEmail(_emailEditController.text.trim())) {
      if (!isTestMode) {
        LoadingIndicatorDialog().show(context);
      }
      response = await authentitcationHelper
          .editCurrentUserEmail(_emailEditController.text.trim());
      if (!isTestMode) {
        LoadingIndicatorDialog().dismiss();
      }
    } else {
      response =
          'You did not input a valid email address so the change could not be made. Please try again.';
    }
    ErrorDialogHelper(context: context).showAlertDialog(response);
  }

  @override
  Widget build(BuildContext _context) {
    context = _context;
    return FutureBuilder<String>(
      future: authentitcationHelper.getCurrentUserEmail(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    key: Key("edit_email_prompt"),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Edit your email:",
                          style: TextStyle(
                            fontSize: 30,
                          )),
                    )),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  key: const Key('email_text_field'),
                  hint: snapshot.data as String,
                  controller: _emailEditController,
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 60,
                        width: 250,
                        child: ElevatedButton(
                          key: const Key('edit_email_submit'),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            await commitEmailEdit();
                            if (!isTestMode) {
                              Timer(const Duration(seconds: 2), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditAccountPage(
                                        firestore: firebaseFirestore,
                                        auth: auth,
                                        isTestMode: isTestMode),
                                  ),
                                );
                              });
                            }
                          },
                          child: const Text("Change Email"),
                        ),
                      ),
                    )),
              ],
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
