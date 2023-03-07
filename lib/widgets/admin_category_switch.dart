import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';

///This widget is a switch that the admin can use in order to define
///the availability status of a particular item in the admin choice
///board.
class CategorySwitchButton extends StatefulWidget {
  final String categoryId;
  final bool categoryAvailability;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  CategorySwitchButton(
      {super.key,
      required this.categoryId,
      required this.categoryAvailability,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<CategorySwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<CategorySwitchButton> {
  late FirebaseFunctions firebaseFunctions;
  late bool isAvailable;
  late String buttonText;

  @override
  void initState() {
    super.initState();
    isAvailable = widget.categoryAvailability;
    buttonText = isAvailable ? "On display" : "Hidden";
    firebaseFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
  }

  ///Switch the state of the switch of item [itemKey] from true to false or conversely.
  ///If availability status has been saved in the db, returns true, else false.
  Future<bool> switchBooleanValue(String itemKey) async {
    final bool val =
        await firebaseFunctions.updateCategoryAvailability(categoryId: itemKey);

    if (val) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Category availability could not be changed. Make sure you are connected to internet.",
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
        final bool trigger = await switchBooleanValue(widget.categoryId);
        if (trigger) {
          setState(() {
            isAvailable = value;
          });
        }
      },
    );
    // return ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       textStyle: TextStyle(
    //         fontSize: 20,
    //         fontWeight: FontWeight.bold,
    //       ),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //     ),
    //     child: Text(buttonText),
    //     //    style: TextStyle(fontSize: 14)
    //     onPressed: () async {
    //       final bool trigger = await switchBooleanValue(widget.categoryId);
    //       if (trigger) {
    //         print("\n\nIS AVAILABLE:");
    //         print(isAvailable);
    //         setState(() {
    //           buttonText = isAvailable ? "On display" : "Hidden";
    //           isAvailable = !isAvailable;
    //         });
    //         print("\n\nNEW IS AVAILABLE:");
    //         print(isAvailable);
    //         print("\nNEW TEXT:");
    //         print(buttonText);
    //       }
    //     });
  }
}
