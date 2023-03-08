import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

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
  Future deleteImageFromCloud({required String imageUrl}) {
    return storage.refFromURL(imageUrl).delete().onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Take an image and upload it to Firestore Cloud Storage with
  /// a unique name. Return the URL of the image from the cloud
  Future<String?> uploadImageToCloud(
      {required File image, required String itemName}) async {
    String uniqueName =
        itemName + DateTime.now().millisecondsSinceEpoch.toString();
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
  Future updateCategoryRanks(
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

  /// Updates the availability of every categoryItems of item [itemKey]
  /// in all categoryItems collections holding it.
  Future availabilityMultiPathUpdate(
      {required String itemKey, required bool currentValue}) async {
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

        await itemReference.update({"is_available": !currentValue});
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
            itemKey: itemId, currentValue: currentValue),
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
