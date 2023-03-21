
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';
import '../../services/auth.dart';
import '../loading_indicators/loading_indicator.dart';

/// This widget returns all the components and functionalitlies necessary for the user to change their password.
class EditPasswordSection extends StatelessWidget {
  late final BuildContext context;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final Auth authentitcationHelper;
  late final bool isTestMode;

  EditPasswordSection(
      {super.key,
      required this.authentitcationHelper,
      required this.isTestMode});

  // Verify the validity of fields and execute the change of a user's password.
  Future commit_password_edit() async {
    String response;
    if (_currentPasswordController.text.trim() != "" &&
        _newPasswordController.text.trim() != "" &&
        _confirmPasswordController.text.trim() != "") {
      if (_newPasswordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        if (!isTestMode) {
          LoadingIndicatorDialog().show(context);
        }
        response = await authentitcationHelper.editCurrentUserPassword(
            _currentPasswordController.text.trim(),
            _newPasswordController.text.trim());
        if (!isTestMode) {
          LoadingIndicatorDialog().dismiss();
        }
      } else {
        response =
            'The new password confirmation does not match the new password you demanded. Please try again.';
      }
    } else {
      response =
          'Some fields required to operate your password change were not filled in. Please try again.';
    }
    ErrorDialogHelper(context: context).show_alert_dialog(response);
  }

  @override
  Widget build(BuildContext _context) {
    context = _context;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Edit your password:",
              key: Key('edit_password_prompt'),
              style: TextStyle(
                fontSize: 30,
              ),
            )),
      ),
      const SizedBox(
        height: 15,
      ),
      MyTextField(
        key: const Key('current_password_input'),
        hint: "Current password",
        controller: _currentPasswordController,
        isPassword: true,
      ),
      const SizedBox(
        height: 15,
      ),
      MyTextField(
        key: const Key('new_password_input'),
        hint: "New password",
        controller: _newPasswordController,
        isPassword: true,
      ),
      const SizedBox(
        height: 15,
      ),
      MyTextField(
        key: const Key('confirm_new_password_input'),
        hint: "Password confirmation",
        controller: _confirmPasswordController,
        isPassword: true,
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
                key: const Key('edit_password_submit'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  commit_password_edit();
                },
                child: Text("Change Password"),
              ),
            ),
          ))
    ]);
  }
}
