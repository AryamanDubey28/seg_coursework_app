import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/add_choice_board_item.dart';
import 'package:seg_coursework_app/services/check_connection.dart';

import '../dialogs/hero_dialog_route.dart';

/// The button in the Admin Choice Boards page to add
/// a new item to a category
class AddItemButton extends StatefulWidget {
  final String categoryId;
  final bool mock;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  AddItemButton(
      {super.key,
      required this.categoryId,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<AddItemButton> createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  @override
  void dispose() {
    if (!widget.mock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: addItem,
      icon: const Icon(Icons.add),
      label: const Text("Add an item"),
    );
  }

  /// open the add item popup (Add choice board item page)
  void addItem() {
    if (!widget.mock && !CheckConnection.isDeviceConnected) {
      // User has no internet connection
      ErrorDialogHelper(context: context).show_alert_dialog(
          "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
      return;
    }
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return AddChoiceBoardItem(
        categoryId: widget.categoryId,
        key: Key("addItemHero-${widget.categoryId}"),
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage,
      );
    }));
  }
}
