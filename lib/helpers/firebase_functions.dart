import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'dart:io';

import 'package:seg_coursework_app/models/timetable.dart';

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

    return categoryItems.doc(itemId).set({
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

  Future<List<ImageDetails>> getLibraryOfImages() async
  {
    List<ImageDetails> library = [];
    try{
      final QuerySnapshot itemsSnapshot = await firestore.collection("items")
      .where("userId", isEqualTo: auth.currentUser!.uid)
      .get();

      if (itemsSnapshot.size == 0) {
      return library;
      }

      for (final DocumentSnapshot item in itemsSnapshot.docs) {
        library.add(ImageDetails(name: item.get('name'), imageUrl: item.get('illustration'), itemId: item.id));
      }
    }
    catch(e)
    {
      print(e);
    }
    

    return library;
  }

  Future<ListOfTimetables> getListOfTimetables() async
  {
    List<Timetable> listOfTimetablesTemp = [];

    try
    {
      final QuerySnapshot workflowsSnapshot = await firestore
      .collection("workflows")
      .where("userId", isEqualTo: auth.currentUser!.uid)
      .get();
      
      if (workflowsSnapshot.size == 0) {
        return ListOfTimetables(listOfLists: listOfTimetablesTemp);
      }
      
      for (final DocumentSnapshot workflow in workflowsSnapshot.docs) {
        final QuerySnapshot workflowItems = await firestore
        .collection('workflowItems/${workflow.id}/items')
        .orderBy('rank')
        .get();
      
        List<ImageDetails> itemsList = [];
        for(final DocumentSnapshot workflowItem in workflowItems.docs)
        {
          itemsList.add(
            ImageDetails(
              name: workflowItem.get('name'), 
              imageUrl: workflowItem.get("illustration"), 
              itemId: workflowItem.id
            )
          );
        }
      
        listOfTimetablesTemp.add(
          Timetable(
            title: workflow.get("title"), 
            listOfImages: itemsList, 
            workflowId: workflow.id
          )
        );
      }
    }
    catch(e)
    {
      print(e);
    }

    return ListOfTimetables(listOfLists: listOfTimetablesTemp);
  }

  Future saveWorkflowToFirestore(
        {required Timetable timetable}) async {

    String workflowId = await createWorkflow(
      title: timetable.title,
    )
    .onError((error, stackTrace) => throw FirebaseException(plugin: stackTrace.toString()));
    timetable.setID(id: workflowId);

    for(int i = 0 ; i < timetable.length() ; i++)
    {
    
      await createWorkflowItem(
        workflowItem: timetable.get(i),
        workflowId: workflowId,
      )
      .onError((error, stackTrace) => throw FirebaseException(plugin: stackTrace.toString()));
    }
        
  }

  ///Create a new workflow and add it to the database.
  Future<String> createWorkflow({required String title})
  async {
    CollectionReference workflows = firestore.collection('workflows');

    return workflows
      .add({
        'title': title,
        'userId': auth.currentUser!.uid,
      })
      .then((workflow) => workflow.id)
      .catchError((error, stackTrace) {
        return throw FirebaseException(plugin: stackTrace.toString());
      });

  }

  Future createWorkflowItem(
      {
      required ImageDetails workflowItem,
      required String workflowId,
      }) async {
    CollectionReference workflowItems =
        firestore.collection('workflowItems/$workflowId/items');

    return workflowItems.doc(workflowItem.itemId).set({
      'illustration': workflowItem.imageUrl,
      'name': workflowItem.name,
      'rank': await getNewWorkflowItemRank(workflowId: workflowId),
      'userId': auth.currentUser!.uid
      // ignore: void_checks
    }).onError((error, stackTrace) => throw FirebaseException(plugin: stackTrace.toString()));
    
    
  }

  /// Return an appropriate rank for a new workflowItem in the
  /// given workflow (one more than the highest rank or zero if empty)
  Future<int> getNewWorkflowItemRank({required String workflowId}) async {
    final QuerySnapshot querySnapshot =
        await firestore.collection('workflowItems/$workflowId/items').get();
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
      return false;
    }
    return true;
  }

  ///Delete a workflow.
  Future deleteWorkflow(
    {required Timetable timetable}) async {
      String workflowId = timetable.workflowId;
      try {
        CollectionReference workflows = firestore.collection('workflows');
        
        DocumentSnapshot workflow = await workflows.doc(workflowId).get();
        if (!workflow.exists) {
          return throw FirebaseException(plugin: "workflow does not exist!");
        }
        
        await deleteWorkflowItems(workflowId: workflowId);//.then((value) => null);
        
        return workflows.doc(workflowId).delete().onError((error, stackTrace) {
          return throw FirebaseException(plugin: stackTrace.toString());
        });
      }catch (e) {
        return throw FirebaseException(plugin: e.toString());
      }
    }

  ///Delete a workflow's associated items.
  Future deleteWorkflowItems(
      {required String workflowId}) async {

    final QuerySnapshot workflowItemFolder = await firestore.collection('workflowItems/$workflowId/items').get();

    for(final DocumentSnapshot workflowItem in workflowItemFolder.docs)
    {
      final DocumentReference workflowItemReference = firestore.collection('workflowItems/$workflowId/items').doc(workflowItem.id);
      await workflowItemReference.delete().onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
      });
    }
  }
}
