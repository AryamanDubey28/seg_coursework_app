import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'dart:io';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class which holds methods to manipulate the Firebase database
class FirebaseFunctions {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  FirebaseFunctions(
      {required this.auth, required this.firestore, required this.storage});

  // #### Adding items functions ####

  /// Add a new entry to the 'items' collection in Firestore with
  /// the given name and image URL.
  /// Return the created item's id
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
  Future<int> getNewCategoryItemRank({required String categoryId}) async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('categoryItems/$categoryId/items').get();
    return querySnapshot.size;
  }

  // #### Edting items functions ####

  /// Update the name of the given item (only in the "items" collection)
  Future updateItemName({required String itemId, required String newName}) {
    CollectionReference items = firestore.collection('items');

    return items
        .doc(itemId)
        .update({'name': newName}).catchError((error, stackTrace) {
      // ignore: invalid_return_type_for_catch_error
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Update the name of all the "categoryItems" which have
  /// the given itemId as their id
  Future updateCategoryItemsName(
      {required String itemId, required String newName}) async {
    final QuerySnapshot categoriesSnapshot = await firestore
        .collection('categories')
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .get();

    if (categoriesSnapshot.size == 0) {
      return throw FirebaseException(plugin: "User has no categories");
    }

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .where(FieldPath.documentId, isEqualTo: itemId)
          .get();

      for (final DocumentSnapshot categoryItem in categoryItemsSnapshot.docs) {
        final DocumentReference categoryItemReference = firestore
            .collection('categoryItems/${category.id}/items')
            .doc(categoryItem.id);

        await categoryItemReference.update({'name': newName});
      }
    }
  }

  /// Delete the image in Firestore Cloud Storage which holds
  /// the given imageUrl
  Future deleteImageFromCloud({required String imageUrl}) async {
    return storage
        .refFromURL(imageUrl)
        .delete()
        .catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Take an image and upload it to Firestore Cloud Storage with
  /// a unique name. Return the URL of the image from the cloud
  Future<String?> uploadImageToCloud(
      {required File image,
      required String name,
      bool overrideUniqueName = false}) async {
    String uniqueName = name + DateTime.now().millisecondsSinceEpoch.toString();
    // A reference to the image from the cloud's root directory
    Reference imageRef;
    if (!overrideUniqueName) {
      imageRef = storage.ref().child('images').child(uniqueName);
    } else {
      imageRef = storage.ref().child('images').child(name);
    }
    try {
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } on FirebaseException catch (error) {
      rethrow;
    }
  }

  /// Update the image (illustration) of the given item (only in the "items" collection)
  Future updateItemImage(
      {required String itemId, required String newImageUrl}) {
    CollectionReference items = firestore.collection('items');

    return items
        .doc(itemId)
        .update({'illustration': newImageUrl}).catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Update the image (illustration) of all the "categoryItems" which have
  /// the given itemId as their id
  Future updateCategoryItemsImage(
      {required String itemId, required String newImageUrl}) async {
    final QuerySnapshot categoriesSnapshot = await firestore
        .collection('categories')
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .get();

    if (categoriesSnapshot.size == 0) {
      return throw FirebaseException(plugin: "User has no categories");
    }

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .where(FieldPath.documentId, isEqualTo: itemId)
          .get();

      for (final DocumentSnapshot categoryItem in categoryItemsSnapshot.docs) {
        final DocumentReference categoryItemReference = firestore
            .collection('categoryItems/${category.id}/items')
            .doc(categoryItem.id);

        await categoryItemReference.update({'illustration': newImageUrl});
      }
    }
  }

  /// Behaves as an assertion to check that an item exists.
  /// Return True if it does exist, otherwise throw an error
  Future<bool> itemExists({required String itemId}) async {
    DocumentSnapshot item =
        await firestore.collection('items').doc(itemId).get();
    return item.exists;
  }

  // #### Deleting items functions ####

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

  /// Should be called after deleting a categoryItem. Decrement the ranks
  /// of all documents which have a rank higher than the deleted categoryItem
  Future updateCategoryItemsRanks(
      {required String categoryId, required int removedRank}) async {
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

  // #### Editing categories functions ####

  /// Update category title with new name
  Future updateCategoryName(
      {required String categoryId, required String newName}) {
    CollectionReference categories = firestore.collection('categories');

    return categories
        .doc(categoryId)
        .update({'title': newName}).catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Change category image to new provided image
  Future updateCategoryImage(
      {required String categoryId, required String newImageUrl}) {
    CollectionReference categories = firestore.collection('categories');

    return categories
        .doc(categoryId)
        .update({'illustration': newImageUrl}).catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Behaves as an assertion to check that a category exists.
  /// Return True if it does exist, otherwise throw an error
  Future<bool> categoryExists({required String categoryId}) async {
    DocumentSnapshot category =
        await firestore.collection('categories').doc(categoryId).get();
    return category.exists;
  }

  // #### Deleting categories functions ####

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

  /// Decrement ranks of higher ranking categories
  Future updateAllCategoryRanks({required int removedRank}) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('categories')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .where('rank', isGreaterThan: removedRank)
        .get();

    for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      final DocumentReference documentReference =
          firestore.collection('categories').doc(documentSnapshot.id);
      await documentReference
          .update({'rank': documentSnapshot.get('rank') - 1});
    }
  }

  /// Delete category document from categories collection
  /// Delete associated categoryItems document
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

  // #### updating availabilities functions ####

  /// First, the method updates the availability status of the category [categoryId] in the 'categories' collection,
  /// then, if the operation is successful, it calls availabilityMultiPathUpdate method.
  /// If not, it returns boolean false.
  Future updateCategoryAvailability({required String categoryId}) async {
    try {
      final DocumentReference itemRef =
          firestore.collection("categories").doc(categoryId);
      final DocumentSnapshot documentSnapshot = await itemRef.get();
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      final bool? currentValue = data["is_available"];
      // Items collection update
      await firestore
          .collection("categories")
          .doc(categoryId)
          .update({"is_available": !currentValue!});
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Updates the availability of every categoryItems of item [itemKey]
  /// in all categoryItems collections holding it.
  Future availabilityMultiPathUpdate(
      {required String itemKey, required bool newAvailabilityValue}) async {
    final QuerySnapshot categoriesSnapshot = await firestore
        .collection('categories')
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .get();

    if (categoriesSnapshot.size == 0) {
      return throw FirebaseException(plugin: "User has no categories");
    }

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .where(FieldPath.documentId, isEqualTo: itemKey)
          .get();

      for (final DocumentSnapshot item in categoryItemsSnapshot.docs) {
        final DocumentReference itemReference = firestore
            .collection('categoryItems/${category.id}/items')
            .doc(item.id);

        await itemReference.update({"is_available": newAvailabilityValue});
      }
    }
  }

  /// First, the method updates the availability status of the item [itemId] in the 'items' collection,
  /// then, if the operation is successful, it calls availabilityMultiPathUpdate method.
  /// If not, it returns boolean false.
  Future updateItemAvailability({required String itemId}) async {
    try {
      final DocumentReference itemRef =
          firestore.collection("items").doc(itemId);
      final DocumentSnapshot documentSnapshot = await itemRef.get();
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      final bool? currentValue = data["is_available"];
      // Items collection update
      await firestore
          .collection("items")
          .doc(itemId)
          .update({"is_available": !currentValue!}).then(
        (_) => availabilityMultiPathUpdate(
            itemKey: itemId, newAvailabilityValue: !currentValue),
      );
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  // #### updating ranks functions ####

  /// When category reordering occurs, updates the new rank of each category in firebase.
  /// The function creates an ordered list (depending on the ranks) of categories before the reordering,
  /// applies reordering changes to the list and then upload to firebase the new position
  /// of the categories in the list as their updated ranks.
  ///
  /// [oldRank] The initial index (position) of the dragged category.
  /// [newRank] The new index (position) of the dragged category.
  Future saveCategoryOrder({required int oldRank, required int newRank}) async {
    try {
      // Retrieve all categories of user as an ordered list
      QuerySnapshot categories = await firestore
          .collection('categories')
          .where("userId", isEqualTo: auth.currentUser!.uid)
          .get();

      var lst = [];
      for (var cat in categories.docs) {
        lst.add(cat);
      }

      lst.sort((a, b) =>
          (a.data()["rank"] as num).compareTo(b.data()["rank"] as num));

      final cat = lst.removeAt(oldRank);
      lst.insert(newRank, cat);

      // loop through updated list and update database
      for (var i = 0; i < lst.length; i++) {
        await firestore
            .collection("categories")
            .doc(lst[i].id)
            .update({"rank": i});
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  /// When categoryItems reordering occurs, updates the new rank of each categoryItem in firebase.
  /// The function creates an ordered list of categoryItems before the reordering,
  /// applies reordering changes to the list and then upload to firebase the new position
  /// of the categoryItems in the list as their updated ranks.
  ///
  /// [categoryId] The category concerned by the reordering.
  /// [oldItemIndex] The initial index (position) of the dragged categoryItem.
  /// [newItemIndex] The new index (position) of the dragged categoryItem.
  Future saveCategoryItemOrder(
      {required String categoryId,
      required int oldItemIndex,
      required int newItemIndex}) async {
    try {
      QuerySnapshot categoryItems =
          await firestore.collection('categoryItems/$categoryId/items').get();

      var lst = [];
      for (var item in categoryItems.docs) {
        lst.add(item);
      }

      lst.sort((a, b) =>
          (a.data()["rank"] as num).compareTo(b.data()["rank"] as num));

      final item = lst.removeAt(oldItemIndex);
      lst.insert(newItemIndex, item);

      for (var i = 0; i < lst.length; i++) {
        await firestore
            .collection("categoryItems/$categoryId/items")
            .doc(lst[i].id)
            .update({"rank": i});
      }
    } catch (e) {
      return false;
    }
    return true;
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

  /// Store the given Categories in the cache under the name
  /// "<userId>-categories"
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

  /// Return the user's choice boards data that's in the cache.
  /// Throw an exception if the cache is empty
  Future<Categories> getUserCategoriesFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesJson =
        prefs.getString('${auth.currentUser!.uid}-categories');
    if (categoriesJson != null) {
      return Categories(categories: []).fromJsonString(categoriesJson);
    } else {
      throw Exception("No data in the cache!");
    }
  }
}
