import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_read_functions.dart';

class FirebaseCreateFunctions {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  FirebaseCreateFunctions(
      {required this.auth, required this.firestore, required this.storage});

  // #### Adding items functions ####

  /// Add a new entry to the 'items' collection in Firestore with
  /// the given name and image URL.
  /// Return the created item's id
  /// [name] the item's name.
  /// [imageUrl] the url of the item's image.
  Future<String> createItem(
      {required String name, required String imageUrl}) async {
    CollectionReference items = firestore.collection('items');

    return items
        .add({
          'name': name,
          'illustration': imageUrl,
          'is_available': true,
          'userId': auth.currentUser!.uid
        })
        .then((item) => item.id)
        .catchError((error, stackTrace) {
          return throw FirebaseException(plugin: stackTrace.toString());
        });
  }

  /// Add a new entry to the 'categoryItems' collection in Firestore with
  /// the given item and category information.
  /// Note: the categoryItem will have the same id as the item
  /// [name] The name of the categoryItem.
  /// [imageUrl] the url of the categoryItem's illustration.
  /// [categoryId] the id of the category for which to create a categoryItem.
  /// [itemId] the id of the item linked with that categoryItem.
  Future createCategoryItem(
      {required String name,
      required String imageUrl,
      required String categoryId,
      required String itemId}) async {
    CollectionReference categoryItems =
        firestore.collection('categoryItems/$categoryId/items');

    categoryItems.doc(itemId).set({
      'illustration': imageUrl,
      'is_available': true,
      'name': name,
      'rank': await getNewCategoryItemRank(categoryId: categoryId),
      'userId': auth.currentUser!.uid
      // ignore: void_checks
    }).onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Return an appropriate rank for a new categoryItem in the
  /// given category (one more than the highest rank or zero if empty)
  /// [categoryId] the id of teh category the item is added to.
  Future<int> getNewCategoryItemRank({required String categoryId}) async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('categoryItems/$categoryId/items').get();
    return querySnapshot.size;
  }

  // #### Adding categories functions ####

  /// Add a new entry to the 'categories' collection in Firestore with
  /// the given item information. Return the created category's id
  Future<String> createCategory(
      {required String name, required String imageUrl}) async {
    CollectionReference categories = firestore.collection('categories');

    return categories
        .add({
          'userId': auth.currentUser!.uid,
          'title': name,
          'illustration': imageUrl,
          'rank': await getNewCategoryRank(uid: auth.currentUser!.uid),
          "is_available": true
        })
        .then((category) => category.id)
        .catchError((error, stackTrace) {
          return throw FirebaseException(plugin: stackTrace.toString());
        });
  }

  /// Return an appropriate rank for a new category
  /// (one more than the highest rank or zero if empty)
  Future<int> getNewCategoryRank({required String uid}) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('categories')
        .where("userId", isEqualTo: uid)
        .get();
    return querySnapshot.size;
  }
}
