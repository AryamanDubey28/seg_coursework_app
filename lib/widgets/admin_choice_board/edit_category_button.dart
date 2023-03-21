import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/edit_choice_board_category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import '../dialogs/hero_dialog_route.dart';

/// Uses new category information to edit existing category
class EditCategoryButton extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImageUrl;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  final bool mock;

  EditCategoryButton(
      {super.key,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImageUrl}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<EditCategoryButton> createState() => _EditCategoryButtonState();
}

class _EditCategoryButtonState extends State<EditCategoryButton> {
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
      onPressed: editCategory,
      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 76, 153)),
    );
  }

  /// open the edit category popup (Edit choice board category page)
  void editCategory() {
    if (!widget.mock && !CheckConnection.isDeviceConnected) {
      // User has no internet connection
      ErrorDialogHelper(context: context).show_alert_dialog(
          "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
      return;
    }
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return EditChoiceBoardCategory(
          key: Key("editCategoryHero-${widget.categoryId}"),
          mock: widget.mock,
          auth: widget.auth,
          storage: widget.storage,
          firestore: widget.firestore,
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
          categoryImageUrl: widget.categoryImageUrl);
    }));
  }
}
