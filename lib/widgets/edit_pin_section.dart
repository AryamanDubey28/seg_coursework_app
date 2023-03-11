import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';
import 'package:seg_coursework_app/widgets/show_alert_dialog.dart';
import '../services/auth.dart';

/// This widget returns all the components and functionalitlies necessary for the user to change their email.
class EditPINSection extends StatelessWidget {
  late BuildContext context;
  final _pinEditController = TextEditingController();
  late final Auth authentitcationHelper;

  EditPINSection({required this.authentitcationHelper});

  // Displays an alert dialog with the text passed as parameter.
  void show_alert_dialog(String text) {
    ShowAlertDialog.show_dialog(context, text);
  }

  bool validatePin(String pin) {
    return pin.length == 4 && num.tryParse(pin) != null;
  }

  // Verify the validity of fields and execute the change of a user's email.
  Future commit_pin_edit() async {
    String response = "";
    String pin = _pinEditController.text.trim();
    if (pin != "" && validatePin(pin)) {
      String pin = _pinEditController.text.trim();
      response = await authentitcationHelper.editCurrentUserPIN(pin);
    } else {
      response =
          'You did not input a valid PIN so the change could not be made. Please try again. \nValid PINs are made up of 4 digits';
    }
    show_alert_dialog(response);
  }

  Future makePin(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                "Enter a PIN that you would like to lock the child account with"),
            content: TextField(
              key: Key("enterPINTextField"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]')), //only numbers can be entered
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              controller: _pinEditController,
            ),
            actions: [
              TextButton(
                  key: Key("submitButton"),
                  onPressed: () => submit(context),
                  child: Text("SUBMIT"))
            ],
          ));

  Future<void> submit(BuildContext context) async {
    String result =
        await authentitcationHelper.createPIN(_pinEditController.text.trim());
    show_alert_dialog(result);
    _pinEditController.clear();
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
          if (snapshot.hasError || !validatePin(snapshot.data as String)) {
            //if snapshot has an error, it cannot read the user's PIN from the database therefore, prompts user to make a PIN
            return ElevatedButton(
              key: Key('make_pin_submit'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                makePin(context);
              },
              child: Text("Create PIN"),
            );
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    key: const Key("edit_pin_prompt"),
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
                  isNumericKeyboard: true,
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
