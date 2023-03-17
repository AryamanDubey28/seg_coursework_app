import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/snackbar_manager.dart';
import 'package:seg_coursework_app/models/image_details.dart';

import '../models/timetable.dart';
import '../services/check_connection.dart';
import 'loading_indicator.dart';

///This widget shows the dialog that allows the user to enter a title and save a timetable
class SaveTimetableDialog extends StatefulWidget {
  

  SaveTimetableDialog({super.key, required this.imagesList, required this.saveTimetable, this.isMock = false});
  
  List<ImageDetails> imagesList;
  Function saveTimetable;
  final bool isMock;

  @override
  State<SaveTimetableDialog> createState() => _SaveTimetableDialogState();
}

class _SaveTimetableDialogState extends State<SaveTimetableDialog> {
  //To validate inputs.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    if(!widget.isMock) {
      CheckConnection.stopMonitoring();
    }
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //This is so when the user clicks outside the dialog it clears the text.
    return WillPopScope(
      onWillPop: () async {
        _textEditingController.clear();
        return true;
      },
      child: AlertDialog(
        title: Text('Enter a title for the Timetable to save it'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            key: Key("titleField"),
            maxLength: 30,
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Timetable title'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a title';
              }
              RegExp alphanumeric = RegExp(r'^[\w\s]+$');
              if (!alphanumeric.hasMatch(value)) {
                return 'Title should only contain letters, numbers, and spaces';
              }
              return null;
            },
            onChanged: (value) {
              _formKey.currentState!.validate();
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              _textEditingController.clear();
              Navigator.pop(context);
            },
          ),
          TextButton(
            key: Key("submitButton"),
            child: Text('Submit'),
            onPressed: () async {
              if(!_formKey.currentState!.validate()) {
                SnackBarManager.showSnackBarMessage(context, "Title is not valid!");
                return;
              }
              if(!widget.isMock && !CheckConnection.isDeviceConnected)
              {
                SnackBarManager.showSnackBarMessage(context, "Cannot save timetable. No connection.");
                return;
              }
                
              String title = _textEditingController.text;
              _textEditingController.clear();
              if(!widget.isMock)
              {
                LoadingIndicatorDialog().show(context, text: "Saving timetable...");
              }
              await widget.saveTimetable(timetable: Timetable(title: title, listOfImages: widget.imagesList));
              if (!widget.isMock) {
                LoadingIndicatorDialog().dismiss();
              }
              SnackBarManager.showSnackBarMessage(context, "Timetable saved successfully");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}