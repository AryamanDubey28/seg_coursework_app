import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_functions.dart';

/// Deletes a choiceboard category given ID
class DeleteChoiceBoardCategory extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseFunctions firestoreFunctions;

  DeleteChoiceBoardCategory({super.key, required this.categoryId, required this.categoryName, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    firestoreFunctions = FirebaseFunctions(auth: this.auth, firestore: this.firestore, storage: this.storage);
  }

  @override
  Widget build(BuildContext context) {
    // Return to admin screen if user cancels choice
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Once user confirms choice, call delete function
    Widget deleteButton = TextButton(
      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
      child: Text("Delete"),
      onPressed: () async {
        await firestoreFunctions.deleteCategory(categoryId: categoryId);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      key: Key("confirmationAlert"),
      title: Text("Warning!"),
      content: Text("Are you sure you want to delete '$categoryName'?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    return alert;
  }
}
