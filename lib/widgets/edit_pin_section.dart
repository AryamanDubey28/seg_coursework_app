import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';
import '../services/auth.dart';

/// This widget returns all the components and functionalitlies necessary for the user to change their email.
class EditPINSection extends StatelessWidget {
  late BuildContext context;
  final _pinEditController = TextEditingController();
  late final Auth authentitcationHelper;

  EditPINSection({required this.authentitcationHelper});

  // Displays an alert dialog with the text passed as parameter.
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

  // Verify the validity of fields and execute the change of a user's email.
  Future commit_pin_edit() async {
    String response = "";
    if (_pinEditController.text.trim() != "") {
      LoadingIndicatorDialog().show(context);
      String pin = _pinEditController.text.trim();
      response = await authentitcationHelper.editCurrentUserPIN(pin);
      LoadingIndicatorDialog().dismiss();
    } else {
      response =
          'You did not input a valid PIN so the change could not be made. Please try again.';
    }
    show_alert_dialog(response);
  }

  @override
  Widget build(BuildContext _context) {
    context = _context;
    return FutureBuilder<String>(
      future: authentitcationHelper.getCurrentUserPIN(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print("snapshot has error");
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
                      child: Text("Edit your PIN:",
                          style: TextStyle(
                            fontSize: 30,
                          )),
                    )),
                SizedBox(
                  height: 15,
                ),
                MyTextField(
                  key: Key('pin_text_field'),
                  hint: snapshot.data as String,
                  controller: _pinEditController,
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
                          key: Key('edit_pin_submit'),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: commit_pin_edit,
                          child: Text("Change PIN"),
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
