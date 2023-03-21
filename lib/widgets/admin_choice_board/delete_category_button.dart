import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/delete_choice_board_category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';

/// Button that opens delete category popup when pressed
class DeleteCategoryButton extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  final bool mock;

  DeleteCategoryButton(
      {super.key,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<DeleteCategoryButton> createState() => _DeleteCategoryButtonState();
}

class _DeleteCategoryButtonState extends State<DeleteCategoryButton> {
  @override
  void dispose() {
    if (!widget.mock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!widget.mock && !CheckConnection.isDeviceConnected) {
          // User has no internet connection
          ErrorDialogHelper(context: context).show_alert_dialog(
              "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteChoiceBoardCategory(
                    mock: widget.mock,
                    storage: widget.storage,
                    firestore: widget.firestore,
                    auth: widget.auth,
                    categoryId: widget.categoryId,
                    categoryName: widget.categoryName,
                    categoryImage: widget.categoryImage);
              });
        }
      },
      icon: const Icon(Icons.delete, color: Colors.red),
    );
  }
}
