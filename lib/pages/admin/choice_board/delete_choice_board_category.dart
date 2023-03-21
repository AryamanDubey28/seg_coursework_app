import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import '../../../services/firebase_functions.dart';
import '../../../widgets/loading_indicators/loading_indicator.dart';

/// Deletes a choiceboard category given ID
class DeleteChoiceBoardCategory extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  final bool mock;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseFunctions firestoreFunctions;

  DeleteChoiceBoardCategory(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage,
      this.mock = false,
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
      key: const Key("cancelCategoryDelete"),
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Once user confirms choice, call delete function
    Widget deleteButton = TextButton(
      key: const Key("confirmCategoryDelete"),
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red)),
      child: const Text("Delete"),
      onPressed: () async {
        try {
          if (!mock) {
            LoadingIndicatorDialog().show(context);
          }

          int deletedCategoryRank =
              await firestoreFunctions.getCategoryRank(categoryId: categoryId);
          await firestoreFunctions.deleteCategory(categoryId: categoryId);
          await firestoreFunctions.updateAllCategoryRanks(
              removedRank: deletedCategoryRank);
          await firestoreFunctions.deleteImageFromCloud(
              imageUrl: categoryImage);

          if (!mock) {
            LoadingIndicatorDialog().dismiss();
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminChoiceBoards(
                mock: mock, auth: auth, firestore: firestore, storage: storage),
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$categoryName successfully deleted!")),
          );
        } on Exception catch (e) {
          if (!mock) {
            LoadingIndicatorDialog().dismiss();
          }
          print(e);
          ErrorDialogHelper(context: context).show_alert_dialog(
              "An error occurred while communicating with the database. \nPlease make sure you are connected to the internet.");
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      key: Key("deleteCategoryAlert-$categoryId"),
      title: const Text("Warning!"),
      content: Text("Are you sure you want to delete '$categoryName'?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    return alert;
  }
}
