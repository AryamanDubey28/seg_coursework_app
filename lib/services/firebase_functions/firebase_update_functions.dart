import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'dart:io';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseUpdateFunctions {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  FirebaseUpdateFunctions(
      {required this.auth, required this.firestore, required this.storage});
  
  // #### Edting items functions ####

  /// Update the name of the given item (only in the "items" collection)
  /// [itemId] the id of the item to update.
  /// [newName] the name value to update to.
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
  /// [itemId] the id of the item.
  /// [newName] the name to update to.
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

  /// Take an image and upload it to Firestore Cloud Storage with
  /// a unique name. Return the URL of the image from the cloud
  /// [image] the file to upload.
  /// [name] the name of he image.
  Future<String?> uploadImageToCloud(
      {required File image, required String name}) async {
    String uniqueName = name + DateTime.now().millisecondsSinceEpoch.toString();
    // A reference to the image from the cloud's root directory
    Reference imageRef = storage.ref().child('images').child(uniqueName);
    try {
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } on FirebaseException catch (error) {
      rethrow;
    }
  }

  /// Update the image (illustration) of the given item (only in the "items" collection)
  /// [itemId] the id of the item to update.
  /// [newImageUrl] the new value of the illustration.
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

    // Update the image for the relevant categoryItems of each category.
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






}
