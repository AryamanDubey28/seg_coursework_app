import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';

/// The trash (delete) button for items in the Admin Choice Boards page
/// and its functions
class DeleteItemButton extends StatefulWidget {
  final String categoryId;
  final String itemName;
  final String itemId;

  const DeleteItemButton(
      {super.key,
      required this.categoryId,
      required this.itemId,
      required this.itemName});

  @override
  State<DeleteItemButton> createState() => _DeleteItemButtonState();
}

class _DeleteItemButtonState extends State<DeleteItemButton> {
  final firestoreFunctions = FirebaseFunctions();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showAlertDialog(context),
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  /// Alert dialog to make the user confirm deleting the item
  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          key: Key("deleteItemAlert-${widget.itemId}"),
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete ${widget.itemName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                try {
                  int deletedCategoryItemRank =
                      await firestoreFunctions.getCategoryItemRank(
                          categoryId: widget.categoryId, itemId: widget.itemId);
                  await firestoreFunctions.deleteCategoryItem(
                      categoryId: widget.categoryId, itemId: widget.itemId);
                  await firestoreFunctions.updateCategoryRanks(
                      categoryId: widget.categoryId,
                      removedRank: deletedCategoryItemRank);
                  // go back to choice boards page
                  Navigator.of(context).pop();
                  // update message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("${widget.itemName} deleted successfully.")),
                  );
                } on Exception catch (e) {
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
            ),
          ],
        );
      },
    );
  }
}
