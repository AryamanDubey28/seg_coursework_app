import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';

///This widget is a switch that the admin can use in order to define 
///the availability status of a particular item in the admin choice 
///board.
class SwitchButton extends StatefulWidget {
  final String itemId;
  final bool itemAvailability;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  SwitchButton(
      {super.key,
      required this.itemId,
      required this.itemAvailability,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  late FirebaseFunctions firebaseFunctions;
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    isAvailable = widget.itemAvailability;
    firebaseFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
  }
  ///Switch the state of the switch of item [itemKey] from true to false or conversely.
  ///If availability status has been saved in the db, returns true, else false.
  Future<bool> switchBooleanValue(String itemKey) async {
    final bool val =
        await firebaseFunctions.updateItemAvailability(itemId: itemKey);

    if (val) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Item availability could not be changed. Make sure you are connected to internet.",
                style: TextStyle(fontSize: 20),
              ),
            );
          });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      key: const Key("adminSwitch"),
      value: isAvailable,
      onChanged: (bool value) async {
        final bool trigger = await switchBooleanValue(widget.itemId);
        if (trigger) {
          setState(() {
            isAvailable = value;
          });
        }
      },
    );
  }
}
