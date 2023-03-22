import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/check_connection.dart';

///This widget is used to create toggleSwitches able to switch the is_available value
///of a database document (categories or items).
class AvailabilitySwitchToggle extends StatefulWidget {
  final String documentId;
  final bool documentAvailability;
  final bool isCategory;
  final bool mock;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  AvailabilitySwitchToggle(
      {super.key,
      required this.documentId,
      required this.documentAvailability,
      required this.isCategory,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<AvailabilitySwitchToggle> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<AvailabilitySwitchToggle> {
  late FirebaseFunctions firebaseFunctions;
  late bool isAvailable;

  @override
  void dispose() {
    if (!widget.mock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isAvailable = widget.documentAvailability;
    firebaseFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
  }

  /// Reloads the AdminChoiceBoards page
  void refresh() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AdminChoiceBoards(
          mock: widget.mock,
          auth: widget.auth,
          firestore: widget.firestore,
          storage: widget.storage,
        ),
      ),
    );
  }

  /// Switches the is_available field depending if it's
  /// a category or an item. Return true if no errors occured, otherwise false.
  Future<bool> switchAvailabilityValue(
      String documentId, bool isCategory) async {
    bool val;
    if (isCategory) {
      val = await firebaseFunctions.updateCategoryAvailability(
          categoryId: documentId);
    } else {
      val = await firebaseFunctions.updateItemAvailability(itemId: documentId);
    }

    if (val) {
      return true;
    } else {
      ErrorDialogHelper(context: context)
          .showAlertDialog(getFailedUpdateText(isCategory));
      return false;
    }
  }

  /// Get the error text depending on if it's a category or an item
  String getFailedUpdateText(bool isCategory) {
    if (isCategory) {
      return "Category availability could not be changed. Make sure you are connected to internet.";
    } else {
      return "Item availability could not be changed. Make sure you are connected to internet.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      key: const Key("adminSwitch"),
      value: isAvailable,
      onChanged: (bool value) async {
        if (!widget.mock && !CheckConnection.isDeviceConnected) {
          // User has no internet connection
          ErrorDialogHelper(context: context).showAlertDialog(
              "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
        } else {
          final bool trigger = await switchAvailabilityValue(
              widget.documentId, widget.isCategory);
          if (trigger) {
            setState(() {
              isAvailable = value;
            });
            refresh();
          }
        }
      },
    );
  }
}
