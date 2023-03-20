import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A class which holds methods to manipulate the Firebase database
class FirebaseDeleteFunctions {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  FirebaseDeleteFunctions(
      {required this.auth, required this.firestore, required this.storage});

  /// Delete the image in Firestore Cloud Storage which holds
  /// the given imageUrl
  /// [imageUrl] the url of the image to delete.
  Future deleteImageFromCloud({required String imageUrl}) async {
    return storage
        .refFromURL(imageUrl)
        .delete()
        .catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Delete the categoryItem that's associated with the given categoryId and
  /// itemId from Firestore
  Future deleteCategoryItem(
      {required String categoryId, required String itemId}) async {
    CollectionReference categoryItems =
        firestore.collection('categoryItems/$categoryId/items');

    DocumentSnapshot categoryItem = await categoryItems.doc(itemId).get();
    if (!categoryItem.exists) {
      return throw FirebaseException(plugin: "categoryItem does not exist!");
    }

    return categoryItems.doc(itemId).delete().onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Delete category document from categories collection.
  Future deleteCategory({required String categoryId}) async {
    CollectionReference categories = firestore.collection('categories');

    DocumentSnapshot category = await categories.doc(categoryId).get();
    if (!category.exists) {
      return throw FirebaseException(plugin: "category does not exist!");
    }

    await deleteCategoryItems(categoryId: categoryId);

    // ignore: void_checks
    return categories.doc(categoryId).delete().onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  ///Delete a category's associated items.
  Future deleteCategoryItems({required String categoryId}) async {
    final QuerySnapshot categoryItemFolder =
        await firestore.collection('categoryItems/$categoryId/items').get();

    for (final DocumentSnapshot categoryItem in categoryItemFolder.docs) {
      final DocumentReference categoryItemReference = firestore
          .collection('categoryItems/$categoryId/items')
          .doc(categoryItem.id);
      await categoryItemReference.delete();
    }
  }
}
