import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';
import '../services/auth.dart';

/// This widget returns all the components and functionalitlies necessary for the user to change their email.
class EditEmailSection extends StatelessWidget {
  late final BuildContext context;
  final _emailEditController = TextEditingController();
  late final Auth authentitcationHelper;
  late bool isTestMode;

  EditEmailSection(
      {super.key,
      required this.authentitcationHelper,
      required this.isTestMode});

  // Verify the validity of fields and execute the change of a user's email.
  Future commit_email_edit() async {
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
    ErrorDialogHelper(context: context).show_alert_dialog(response);
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
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Edit your email:",
                          style: TextStyle(
                            fontSize: 30,
                          )),
                    )),
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
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: commit_email_edit,
                          child: Text("Change Email"),
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
