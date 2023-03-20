import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'dart:io';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseReadFunctions {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  FirebaseReadFunctions(
      {required this.auth, required this.firestore, required this.storage});

  /// Return the rank field of a category given the categoryId and
  Future<dynamic> getCategoryRank({required String categoryId}) {
    return firestore
        .collection('categories')
        .doc(categoryId)
        .get()
        .then((category) {
      return category.get("rank");
    }).onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Return the rank field of a categoryItem given the categoryId and
  /// itemId
  Future getCategoryItemRank(
      {required String categoryId, required String itemId}) async {
    return firestore
        .collection('categoryItems/$categoryId/items')
        .doc(itemId)
        .get()
        .then((categoryItem) {
      return categoryItem.get("rank");
    }).onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Behaves as an assertion to check that an item exists.
  /// Return True if it does exist, otherwise throw an error
  Future<bool> itemExists({required String itemId}) async {
    DocumentSnapshot item =
        await firestore.collection('items').doc(itemId).get();
    return item.exists;
  }

  /// Behaves as an assertion to check that a category exists.
  /// Return True if it does exist, otherwise throw an error
  Future<bool> categoryExists({required String categoryId}) async {
    DocumentSnapshot category =
        await firestore.collection('categories').doc(categoryId).get();
    return category.exists;
  }

  // #### Retrieving data functions ####

  /// Return all of the current user's categories with their
  /// categoryItems in the correct rank, converted into "Categories".
  Future<Categories> downloadUserCategories() async {
    Categories userCategories =
        Categories(categories: []); // holds all of the user's data

    final QuerySnapshot categoriesSnapshot = await firestore
        .collection('categories')
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .orderBy('rank')
        .get();

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      // holds the current category's categoryItems
      List<CategoryItem> categoryItems = [];

      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .orderBy('rank')
          .get();

      for (final DocumentSnapshot categoryItem in categoryItemsSnapshot.docs) {
        categoryItems.add(CategoryItem(
          name: categoryItem.get("name"),
          availability: categoryItem.get("is_available"),
          id: categoryItem.id,
          imageUrl: categoryItem.get("illustration"),
          rank: categoryItem.get("rank"),
        ));
      }

      userCategories.add(Category(
        title: category.get("title"),
        rank: category.get("rank"),
        items: categoryItems,
        imageUrl: category.get("illustration"),
        id: category.id,
        availability: category.get("is_available"),
      ));
    }

    return userCategories;
  }

  /// Retrieve the user's choice boards data depending on their connection:
  /// - if connected to the internet:
  ///   - download the data from Firebase
  ///   - store it in the cache and return it
  /// - if not connected to the internet:
  ///   - return the data that's in the cache
  ///   - Throw an exception if the cache is empty
  Future<Categories> getUserCategories() async {
    if (CheckConnection.isDeviceConnected) {
      // The device has internet connection.
      Categories userCategories = await downloadUserCategories();
      await storeCategoriesInCache(userCategories: userCategories);
      return userCategories;
    }

    // The device has no internet connection.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesJson =
        prefs.getString('${auth.currentUser!.uid}-categories');
    if (categoriesJson != null) {
      return Categories(categories: []).fromJsonString(categoriesJson);
    } else {
      throw Exception("No data in the cache!");
    }
  }

  /// Store the given Categories in the cache under the name
  /// "<userId>-categories".
  /// [userCategories] the categories associated with a user.
  Future storeCategoriesInCache({required Categories userCategories}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String categoriesJson = userCategories.toJsonString(userCategories);
      await prefs.setString(
          '${auth.currentUser!.uid}-categories', categoriesJson);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
