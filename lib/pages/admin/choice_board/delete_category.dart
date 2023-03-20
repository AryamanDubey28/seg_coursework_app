import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_read_functions.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_update_functions.dart';
import 'package:seg_coursework_app/widgets/general/loading_indicator.dart';
import '../../../services/firebase_functions/firebase_delete_functions.dart';

/// Enables admin user to delete a category given its ID
class DeleteCategory extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseReadFunctions firestoreReadFunctions;
  late final FirebaseDeleteFunctions firestoreDeleteFunctions;
  late final FirebaseUpdateFunctions firestoreUpdateFunctions;

  DeleteCategory(
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
    firestoreDeleteFunctions = FirebaseDeleteFunctions(
        auth: this.auth, firestore: this.firestore, storage: this.storage);
    firestoreUpdateFunctions = FirebaseUpdateFunctions(
        auth: this.auth, firestore: this.firestore, storage: this.storage);
    firestoreReadFunctions = FirebaseReadFunctions(
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
              await firestoreReadFunctions.getCategoryRank(categoryId: categoryId);
          await firestoreDeleteFunctions.deleteCategory(categoryId: categoryId);
          await firestoreUpdateFunctions.updateAllCategoryRanks(
              removedRank: deletedCategoryRank);
          await firestoreDeleteFunctions.deleteImageFromCloud(
              imageUrl: categoryImage);

          LoadingIndicatorDialog().dismiss();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminChoiceBoard(
                auth: auth, firestore: firestore, storage: storage),
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$categoryName successfully deleted!")),
          );
        } on Exception catch (e) {
          LoadingIndicatorDialog().dismiss();
          print(e);
          ErrorDialogHelper(context: context).show_alert_dialog(
              "An error occurred while communicating with the database. \nPlease make sure you are connected to the internet.");
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
