import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';

/// The trash (delete) button for items in the Admin Choice Boards page
/// and its functions
class DeleteItemButton extends StatefulWidget {
  final String categoryId;
  final String itemName;
  final String itemId;
  final String imageUrl;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  DeleteItemButton({super.key, required this.categoryId, required this.itemId, required this.itemName, required this.imageUrl, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<DeleteItemButton> createState() => _DeleteItemButtonState();
}

class _DeleteItemButtonState extends State<DeleteItemButton> {
  late FirebaseFunctions firestoreFunctions;

  @override
  void initState() {
    super.initState();
    firestoreFunctions = FirebaseFunctions(auth: widget.auth, firestore: widget.firestore, storage: widget.storage);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showAlertDialog(context),
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  /// Alert dialog to make the user confirm deleting the item (in one category or all other categories)
  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          key: Key("deleteItemAlert-${widget.itemId}"),
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete ${widget.itemName}?\n\n(Delete Everywhere removes it from other categories too)'),
          actions: <Widget>[
            TextButton(
              key: Key("cancelItemDelete"),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              key: Key("confirmItemDelete"),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.amber)),
              onPressed: deleteCategoryItemFromFirestore,
              child: Text('Delete'),
            ),
            TextButton(
              key: Key("confirmItemDeleteEverywhere"),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: deleteItemEverywhere,
              child: Text('Delete Everywhere'),
            ),
          ],
        );
      },
    );
  }

  /// Handle deleting a categoryItem from firestore:
  /// - delete the "categoryItem" document
  /// - Update the ranks of the categoryItems of that category
  void deleteCategoryItemFromFirestore() async {
    try {
      LoadingIndicatorDialog().show(context);

      int deletedCategoryItemRank = await firestoreFunctions.getCategoryItemRank(categoryId: widget.categoryId, itemId: widget.itemId);
      await firestoreFunctions.deleteCategoryItem(categoryId: widget.categoryId, itemId: widget.itemId);
      await firestoreFunctions.updateCategoryRanks(categoryId: widget.categoryId, removedRank: deletedCategoryItemRank);

      LoadingIndicatorDialog().dismiss();
      // go back to choice boards page
      Navigator.of(context).pop();
      // update message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.itemName} deleted successfully.")),
      );
    } on Exception catch (e) {
      LoadingIndicatorDialog().dismiss();
      ErrorDialogHelper(context: context).show_alert_dialog('An error occurred while communicating with the database');
    }
  }

  /// Handle deleting an item from firestore:
  /// - delete the "item" document
  /// - delete any "categoryItem" documents
  /// - Update the ranks of the other categoryItems
  void deleteItemEverywhere() async {
    try {
      LoadingIndicatorDialog().show(context);

      await firestoreFunctions.deleteImageFromCloud(imageUrl: widget.imageUrl);
      await firestoreFunctions.deleteItem(itemId: widget.itemId);
      await firestoreFunctions.deleteAllCategoryItemsForItem(itemId: widget.itemId); // This function also handles updating ranks of categoryItems

      LoadingIndicatorDialog().dismiss();
      // go back to choice boards page
      Navigator.of(context).pop();
      // update message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.itemName} successfully deleted from everywhere.")),
      );
    } on Exception catch (e) {
      LoadingIndicatorDialog().dismiss();
      ErrorDialogHelper(context: context).show_alert_dialog('An error occurred while communicating with the database');
    }
  }
}
