import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';

import '../../helpers/firebase_functions.dart';

/// Deletes a choiceboard category given ID
class DeleteChoiceBoardCategory extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseFunctions firestoreFunctions;

  DeleteChoiceBoardCategory(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    firestoreFunctions = FirebaseFunctions(
        auth: this.auth, firestore: this.firestore, storage: this.storage);
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
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red)),
      child: Text("Delete"),
      onPressed: () async {
        try {
          LoadingIndicatorDialog().show(context);

          int deletedCategoryRank =
              await firestoreFunctions.getCategoryRank(categoryId: categoryId);
          await firestoreFunctions.deleteCategory(categoryId: categoryId);
          await firestoreFunctions.updateAllCategoryRanks(
              removedRank: deletedCategoryRank);
          await firestoreFunctions.deleteImageFromCloud(
              imageUrl: categoryImage);

          LoadingIndicatorDialog().dismiss();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Category successfully deleted!")),
          );
        } on Exception catch (e) {
          LoadingIndicatorDialog().dismiss();
          print(e);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: Text(
                        'An error occurred while communicating with the database'));
              });
        }
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
