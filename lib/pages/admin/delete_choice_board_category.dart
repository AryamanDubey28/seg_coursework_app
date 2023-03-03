import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Deletes a choiceboard category given ID
class DeleteChoiceBoardCategory extends StatelessWidget {
  final String categoryId;

  const DeleteChoiceBoardCategory({Key? key, required this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return to admin screen if user cancels choice
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Delete document from firebase collection
    void deleteFromCollection(String collectionName) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(categoryId)
          .delete()
          .then(
            (doc) => print("Document deleted"),
            onError: (e) => print("Error updating document $e"),
          );
    }

    // Once user confirms choice, call delete function
    Widget confirmButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        // Delete associated document from 'categoryItems' collection
        deleteFromCollection("categoryItems");

        // Delete category from 'categories' collection
        deleteFromCollection("categories");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning!"),
      content: Text("Are you sure you want to delete this category?"),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    return alert;
  }
}
