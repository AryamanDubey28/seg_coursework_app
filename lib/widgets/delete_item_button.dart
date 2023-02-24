import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Make updateRank inside deleteCategoryItem
// Catch errors appropriately

/// The trash (delete) button for items in the Admin Choice Boards page
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
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("deleteButton"),
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
                  int deletedCategoryItemRank = await getCategoryItemRank(
                      categoryId: widget.categoryId, itemId: widget.itemId);
                  await deleteCategoryItem(
                      categoryId: widget.categoryId, itemId: widget.itemId);
                  await updateRanks(
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

  /// Delete the categoryItem that's associated with the given categoryId and
  /// itemId from firestore
  Future deleteCategoryItem(
      {required String categoryId, required String itemId}) async {
    CollectionReference categoryItems = FirebaseFirestore.instance
        .collection('categoryItems/$categoryId/items');

    return categoryItems.doc(itemId).delete().onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Return the rank field of a categoryItem given the categoryId and
  /// itemId
  Future<int> getCategoryItemRank(
      {required String categoryId, required String itemId}) async {
    final DocumentSnapshot categoryItem = await FirebaseFirestore.instance
        .collection('categoryItems/$categoryId/items')
        .doc(itemId)
        .get();

    return categoryItem.get("rank");
  }

  /// Should be called after deleting a categoryItem. Decrement the ranks
  /// of all documents which have a rank higher than the deleted categoryItem
  Future<void> updateRanks(
      {required String categoryId, required int removedRank}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await firestore
        .collection('categoryItems/$categoryId/items')
        .where('rank', isGreaterThan: removedRank)
        .get();

    for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      final DocumentReference documentReference = firestore
          .collection('categoryItems/$categoryId/items')
          .doc(documentSnapshot.id);
      await documentReference
          .update({'rank': documentSnapshot.get('rank') - 1});
    }
  }
}
