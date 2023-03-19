import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import '../../../lib/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/categories.dart';

Future<void> main() async {
  late FirebaseFunctions firebaseFunctions;
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockUser = MockUser(uid: "user1");
    firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    when(mockAuth.currentUser).thenReturn(mockUser);
  });
  tearDown(() async {
    mockFirestore = FakeFirebaseFirestore();
  });

  Future<DocumentSnapshot> _createCategory(
      {required String id, int rank = 0, required bool is_available}) async {
    mockFirestore.collection('categories').doc(id).set({
      'title': "Drinks",
      'illustration': "drink.jpeg",
      'userId': mockUser.uid,
      'rank': rank,
      'is_available': is_available
    });
    return mockFirestore.collection('categories').doc(id).get();
  }

  test("create item is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    expect(newItemId, isA<String>());
    DocumentSnapshot item =
        await mockFirestore.collection('items').doc(newItemId).get();
    expect(item.get('name'), name);
    expect(item.get('illustration'), imageUrl);
    expect(item.get('userId'), "user1");
    expect(item.get('is_available'), true);
  });

  test("create items gives unique ids", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    expect(newItemId1, isNot(newItemId2));
  });

  test("user can create more than one item", () async {
    const String name1 = "Water";
    const String imageUrl1 = "Nova-water.jpeg";
    const String name2 = "Apple juice";
    const String imageUrl2 = "Nova-Juice.jpeg";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name1, imageUrl: imageUrl1);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name2, imageUrl: imageUrl2);

    DocumentSnapshot item1 =
        await mockFirestore.collection('items').doc(newItemId1).get();
    DocumentSnapshot item2 =
        await mockFirestore.collection('items').doc(newItemId2).get();

    final QuerySnapshot itemsQuerySnapshot =
        await mockFirestore.collection('items').get();

    expect(itemsQuerySnapshot.size, 2);
    expect(item1.get('name'), name1);
    expect(item2.get('name'), name2);
    expect(item1.get('illustration'), imageUrl1);
    expect(item2.get('illustration'), imageUrl2);
    expect(item1.get('userId'), "user1");
    expect(item2.get('userId'), "user1");
  });

  test("create categoryItem is successful with same id as item", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem.id, newItemId);
    expect(newCategoryItem.get('name'), name);
    expect(newCategoryItem.get('illustration'), imageUrl);
    expect(newCategoryItem.get('userId'), "user1");
    expect(newCategoryItem.get('is_available'), true);
    expect(newCategoryItem.get('rank'), 0);
  });

  test("user can create more than one categoryItem", () async {
    const String name1 = "Water";
    const String imageUrl1 = "Nova-water.jpeg";
    const String name2 = "Apple juice";
    const String imageUrl2 = "Nova-Juice.jpeg";
    const String categoryId = "00xx";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name1, imageUrl: imageUrl1);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name2, imageUrl: imageUrl2);

    await firebaseFunctions.createCategoryItem(
        name: name1,
        imageUrl: imageUrl1,
        categoryId: categoryId,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name2,
        imageUrl: imageUrl2,
        categoryId: categoryId,
        itemId: newItemId2);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId1)
        .get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId2)
        .get();

    final QuerySnapshot categoryItemsQuerySnapshot =
        await mockFirestore.collection('categoryItems/$categoryId/items').get();

    expect(categoryItemsQuerySnapshot.size, 2);
    expect(newCategoryItem1.get('name'), name1);
    expect(newCategoryItem2.get('name'), name2);
    expect(newCategoryItem1.get('illustration'), imageUrl1);
    expect(newCategoryItem2.get('illustration'), imageUrl2);
    expect(newCategoryItem1.get('userId'), "user1");
    expect(newCategoryItem2.get('userId'), "user1");
  });

  test(
      "new categoryItem rank is one more than highest rank (using getNewCategoryItemRank)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId2);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId1)
        .get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId2)
        .get();

    expect(newCategoryItem1.get('rank'), 0);
    expect(newCategoryItem2.get('rank'), 1);
  });

  test("update item name edits the item's name successfully", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    DocumentSnapshot item =
        await mockFirestore.collection('items').doc(newItemId).get();

    expect(item.get('name'), name);
    await firebaseFunctions.updateItemName(
        itemId: newItemId, newName: "Nova Water");

    item = await mockFirestore.collection('items').doc(newItemId).get();
    expect(item.get('name'), "Nova Water");
  });

  test("updating the name of an item that doesn't exist throws an exception",
      () async {
    expect(
        firebaseFunctions.updateItemName(
            itemId: "doesn't exist", newName: "Nove Water"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test("update categoryItem name edits the name successfully (1 categoryItem)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";
    await _createCategory(id: categoryId, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem.get('name'), name);
    await firebaseFunctions.updateCategoryItemsName(
        itemId: newItemId, newName: "Nova Water");

    newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();
    expect(newCategoryItem.get('name'), "Nova Water");
  });

  test(
      "update categoryItem name edits the name successfully (2 categoryItems in 2 categories)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    await _createCategory(id: categoryId1, is_available: true);
    await _createCategory(id: categoryId2, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId2,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('name'), name);
    expect(newCategoryItem2.get('name'), name);
    await firebaseFunctions.updateCategoryItemsName(
        itemId: newItemId, newName: "Nova Water");

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('name'), "Nova Water");
    expect(newCategoryItem2.get('name'), "Nova Water");
  });

  test(
      "updating the name of a categoryItem without having categories throws an exception",
      () async {
    expect(
        firebaseFunctions.updateCategoryItemsName(
            itemId: "doesn't exist", newName: "Nova Water"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test(
      "updating the name of a categoryItem that doesn't exist (when categories exist) does nothing",
      () async {
    await _createCategory(id: "00xx", is_available: true);
    expect(
        await firebaseFunctions.updateCategoryItemsName(
            itemId: "doesn't exist", newName: "Nova Water"),
        null);
  });

  test(
      "updating the name of a categoryItem in a deleted category throws an exception",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    expect(
        firebaseFunctions.updateCategoryItemsName(
            itemId: newItemId, newName: "Nova Water"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test("Uploading image to cloud is successful", () async {
    String? imageUrl = await firebaseFunctions.uploadImageToCloud(
        image: File("assets/test_image.png"), name: "Water");

    expect(imageUrl, isA<String>());
    expect(mockStorage.refFromURL(imageUrl!), isNotNull);
  });

  test("Deleting image from cloud is successful", () async {
    String? imageUrl = await firebaseFunctions.uploadImageToCloud(
        image: File("assets/test_image.png"), name: "Water");

    expect(mockStorage.refFromURL(imageUrl!), isNotNull);
    await firebaseFunctions.deleteImageFromCloud(imageUrl: imageUrl);

    expect(mockStorage.refFromURL(imageUrl), isNotNull);
  });

  test("update item image edits the item's image successfully", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    DocumentSnapshot item =
        await mockFirestore.collection('items').doc(newItemId).get();

    expect(item.get('illustration'), imageUrl);
    await firebaseFunctions.updateItemImage(
        itemId: newItemId, newImageUrl: "Hana-water.jpeg");

    item = await mockFirestore.collection('items').doc(newItemId).get();
    expect(item.get('illustration'), "Hana-water.jpeg");
  });

  test("updating the image of an item that doesn't exist throws an exception",
      () async {
    expect(
        firebaseFunctions.updateItemImage(
            itemId: "doesn't exist", newImageUrl: "Hana-water.jpeg"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test(
      "update categoryItem image edits the image successfully (1 categoryItem)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";
    await _createCategory(id: categoryId, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem.get('illustration'), imageUrl);
    await firebaseFunctions.updateCategoryItemsImage(
        itemId: newItemId, newImageUrl: "Hana-water.jpeg");

    newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();
    expect(newCategoryItem.get('illustration'), "Hana-water.jpeg");
  });

  test(
      "update categoryItem image edits the image successfully (2 categoryItems in 2 categories)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    await _createCategory(id: categoryId1, is_available: true);
    await _createCategory(id: categoryId2, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId2,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('illustration'), imageUrl);
    expect(newCategoryItem2.get('illustration'), imageUrl);
    await firebaseFunctions.updateCategoryItemsImage(
        itemId: newItemId, newImageUrl: "Hana-water.jpeg");

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('illustration'), "Hana-water.jpeg");
    expect(newCategoryItem2.get('illustration'), "Hana-water.jpeg");
  });

  test(
      "updating the image of a categoryItem without having categories throws an exception",
      () async {
    expect(
        firebaseFunctions.updateCategoryItemsImage(
            itemId: "doesn't exist", newImageUrl: "Hana-water.jpeg"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test(
      "updating the image of a categoryItem that doesn't exist (when categories exist) does nothing",
      () async {
    await _createCategory(id: "00xx", is_available: true);
    expect(
        await firebaseFunctions.updateCategoryItemsImage(
            itemId: "doesn't exist", newImageUrl: "Hana-water.jpeg"),
        null);
  });

  test(
      "updating the image of a categoryItem in a deleted category throws an exception",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    expect(
        firebaseFunctions.updateCategoryItemsImage(
            itemId: newItemId, newImageUrl: "Hana-water.jpeg"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test("deleting a categoryItem is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();
    expect(newCategoryItem.exists, true);

    await firebaseFunctions.deleteCategoryItem(
        categoryId: categoryId, itemId: newItemId);

    newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();
    expect(newCategoryItem.exists, false);
  });

  test(
      "deleting a categoryItem doesn't delete other categoryItems in other categories with same itemId",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId2,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.exists, true);
    expect(newCategoryItem2.exists, true);

    await firebaseFunctions.deleteCategoryItem(
        categoryId: categoryId1, itemId: newItemId);

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.exists, false);
    expect(newCategoryItem2.exists, true);
  });

  test("deleting a non existing categoryItem throws exception", () async {
    expect(
        firebaseFunctions.deleteCategoryItem(
            categoryId: "00xx", itemId: "empty"),
        throwsA(isA<FirebaseException>()));
  });

  test("getCategoryItemRank returns correct rank", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId2);

    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId1),
        0);
    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId2),
        1);
  });

  test("getCategoryItemRank throws exception for non existing categoryItems",
      () async {
    expect(
        firebaseFunctions.getCategoryItemRank(
            categoryId: "00xx", itemId: "empty"),
        throwsA(isA<FirebaseException>()));
  });

  test(
      "updateCategoryItemsRanks decrements all ranks of categoryItems higher than given rank",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId3 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId2);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId3);

    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId2),
        1);
    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId3),
        2);

    await firebaseFunctions.updateCategoryItemsRanks(
        categoryId: categoryId,
        removedRank: await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId1));
    await firebaseFunctions.deleteCategoryItem(
        categoryId: categoryId, itemId: newItemId1); // delete isn't necessary

    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId2),
        0);
    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId3),
        1);
  });

  test(
      "updateCategoryItemsRanks does nothing if the deleted categoryItem had highest rank",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId3 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId2);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId3);

    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId1),
        0);
    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId2),
        1);

    await firebaseFunctions.updateCategoryItemsRanks(
        categoryId: categoryId,
        removedRank: await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId3));
    await firebaseFunctions.deleteCategoryItem(
        categoryId: categoryId, itemId: newItemId3); // delete isn't necessary

    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId1),
        0);
    expect(
        await firebaseFunctions.getCategoryItemRank(
            categoryId: categoryId, itemId: newItemId2),
        1);
  });

  test("updateCategoryItemsRanks does nothing if given non existing categoryId",
      () async {
    expect(
        await firebaseFunctions.updateCategoryItemsRanks(
            categoryId: "00xx", removedRank: 1),
        null);
  });

  test("create category is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);

    expect(newCategoryId, isA<String>());
    DocumentSnapshot category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.get('title'), name);
    expect(category.get('illustration'), imageUrl);
    expect(category.get('userId'), "user1");
    expect(category.get('rank'), 0);
  });

  test("create catgories gives unique ids", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId1 =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);
    String newCategoryId2 =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);

    expect(newCategoryId1, isNot(newCategoryId2));
  });

  test("user can create more than one category", () async {
    const String title1 = "Water";
    const String imageUrl1 = "Nova-water.jpeg";
    const String title2 = "Apple juice";
    const String imageUrl2 = "Nova-Juice.jpeg";

    String newCategoryId1 = await firebaseFunctions.createCategory(
        name: title1, imageUrl: imageUrl1);
    String newCategoryId2 = await firebaseFunctions.createCategory(
        name: title2, imageUrl: imageUrl2);

    DocumentSnapshot category1 =
        await mockFirestore.collection('categories').doc(newCategoryId1).get();
    DocumentSnapshot category2 =
        await mockFirestore.collection('categories').doc(newCategoryId2).get();

    final QuerySnapshot categoriesQuerySnapshot =
        await mockFirestore.collection('categories').get();

    expect(categoriesQuerySnapshot.size, 2);
    expect(category1.get('title'), title1);
    expect(category2.get('title'), title2);
    expect(category1.get('illustration'), imageUrl1);
    expect(category2.get('illustration'), imageUrl2);
    expect(category1.get('userId'), "user1");
    expect(category2.get('userId'), "user1");
  });

  test(
      "new category rank is one more than highest rank (using getNewCategoryRank)",
      () async {
    const String name = "Breakfast";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId1 =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);
    String newCategoryId2 =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);

    DocumentSnapshot newCategory1 =
        await mockFirestore.collection('categories').doc(newCategoryId1).get();
    DocumentSnapshot newCategory2 =
        await mockFirestore.collection('categories').doc(newCategoryId2).get();

    expect(newCategory1.get('rank'), 0);
    expect(newCategory2.get('rank'), 1);
  });

  test("update category name edits the category's name successfully", () async {
    const String name = "Breakfast";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);
    DocumentSnapshot category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();

    expect(category.get('title'), name);
    await firebaseFunctions.updateCategoryName(
        categoryId: newCategoryId, newName: "Lunch");

    category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.get('title'), "Lunch");
  });

  test("updating the name of a category that doesn't exist throws an exception",
      () async {
    expect(
        firebaseFunctions.updateCategoryName(
            categoryId: "doesnt exist", newName: "doesnt matter"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test("update category image edits the category's image successfully",
      () async {
    const String name = "Dinner";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);
    DocumentSnapshot category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();

    expect(category.get('illustration'), imageUrl);
    await firebaseFunctions.updateCategoryImage(
        categoryId: newCategoryId, newImageUrl: "Hana-water.jpeg");

    category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.get('illustration'), "Hana-water.jpeg");
  });

  test(
      "updating the image of a category that doesn't exist throws an exception",
      () async {
    expect(
        firebaseFunctions.updateCategoryImage(
            categoryId: "doesn't exist", newImageUrl: "Hana-water.jpeg"),
        throwsA(isInstanceOf<FirebaseException>()));
  });

  test("deleting a category is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);
    DocumentSnapshot category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.exists, true);

    await firebaseFunctions.deleteCategory(categoryId: newCategoryId);

    category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.exists, false);
  });

  test("deleting a non existing category throws exception", () async {
    expect(firebaseFunctions.deleteCategory(categoryId: "0022xx"),
        throwsA(isA<FirebaseException>()));
  });

  test("getCategoryRank returns correct rank", () async {
    const String name = "Breakfast";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId1 =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);
    String newCategoryId2 =
        await firebaseFunctions.createCategory(name: name, imageUrl: imageUrl);

    expect(
        await firebaseFunctions.getCategoryRank(categoryId: newCategoryId1), 0);
    expect(
        await firebaseFunctions.getCategoryRank(categoryId: newCategoryId2), 1);
  });

  test("getCategoryRank throws exception for non existing categories",
      () async {
    expect(firebaseFunctions.getCategoryRank(categoryId: "00xx"),
        throwsA(isA<FirebaseException>()));
  });

  test(
      "update item availability status edits the is_available field successfully (1 item)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    DocumentSnapshot newCategoryItem =
        await mockFirestore.collection('items').doc(newItemId).get();

    expect(newCategoryItem.get('is_available'), true);

    await firebaseFunctions.updateItemAvailability(itemId: newItemId);

    DocumentSnapshot upCategoryItem =
        await mockFirestore.collection('items').doc(newItemId).get();

    expect(upCategoryItem.get('is_available'), false);
  });

  test(
      "update categoryItem availability status edits the 'is_available' field successfully (1 categoryItems in 1 categories)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    await _createCategory(id: categoryId1, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), true);
    await firebaseFunctions.updateItemAvailability(itemId: newItemId);

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), false);
  });

  test(
      "update categoryItem availability status edits the 'is_available' field successfully (2 categoryItems in 2 categories)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    await _createCategory(id: categoryId1, is_available: true);
    await _createCategory(id: categoryId2, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId2,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), true);
    expect(newCategoryItem2.get('is_available'), true);
    await firebaseFunctions.updateItemAvailability(itemId: newItemId);

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    newCategoryItem2 = await mockFirestore
        .collection('categoryItems/$categoryId2/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), false);
    expect(newCategoryItem2.get('is_available'), false);
  });

  test(
      "update categoryItem availability status two times edits the 'is_available' field successfully two times(1 categoryItems in 1 categories)",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    await _createCategory(id: categoryId1, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), true);
    await firebaseFunctions.updateItemAvailability(itemId: newItemId);

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), false);
    await firebaseFunctions.updateItemAvailability(itemId: newItemId);

    newCategoryItem1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();

    expect(newCategoryItem1.get('is_available'), true);
  });

  test(
      "update item availability status of non-existent item returns a boolean False",
      () async {
    expect(await firebaseFunctions.updateItemAvailability(itemId: "wrongId"),
        false);
  });

  test("Reordering non-existent categories returns false", () async {
    expect(await firebaseFunctions.saveCategoryOrder(oldRank: 2, newRank: 0),
        false);
  });

  test("Reordering non-existent categoryItems returns false", () async {
    const String categoryId1 = "00xx";
    await _createCategory(id: categoryId1, is_available: true);
    expect(
        await firebaseFunctions.saveCategoryItemOrder(
            categoryId: categoryId1, oldItemIndex: 2, newItemIndex: 0),
        false);
  });

  test("Reordering 3 categories updates all rank fields correctly", () async {
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    const String categoryId3 = "11zz";

    var cat1 = await _createCategory(id: categoryId1, is_available: true);
    var cat2 =
        await _createCategory(id: categoryId2, rank: 1, is_available: true);
    var cat3 =
        await _createCategory(id: categoryId3, rank: 2, is_available: true);

    expect(cat1.get('rank'), 0);
    expect(cat2.get('rank'), 1);
    expect(cat3.get('rank'), 2);

    await firebaseFunctions.saveCategoryOrder(oldRank: 2, newRank: 0);

    cat1 = await mockFirestore.collection('categories').doc(categoryId1).get();
    cat2 = await mockFirestore.collection('categories').doc(categoryId2).get();
    cat3 = await mockFirestore.collection('categories').doc(categoryId3).get();

    expect(cat1.get('rank'), 1);
    expect(cat2.get('rank'), 2);
    expect(cat3.get('rank'), 0);
  });

  test(
      "Reordering 5 categories from the lowest rank to highest one updates all rank fields correctly",
      () async {
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    const String categoryId3 = "11zz";
    const String categoryId4 = "11aa";
    const String categoryId5 = "11bb";

    var cat1 = await _createCategory(id: categoryId1, is_available: true);
    var cat2 =
        await _createCategory(id: categoryId2, rank: 1, is_available: true);
    var cat3 =
        await _createCategory(id: categoryId3, rank: 2, is_available: true);
    var cat4 =
        await _createCategory(id: categoryId4, rank: 3, is_available: true);
    var cat5 =
        await _createCategory(id: categoryId5, rank: 4, is_available: true);

    expect(cat1.get('rank'), 0);
    expect(cat2.get('rank'), 1);
    expect(cat3.get('rank'), 2);
    expect(cat4.get('rank'), 3);
    expect(cat5.get('rank'), 4);

    await firebaseFunctions.saveCategoryOrder(oldRank: 4, newRank: 0);

    cat1 = await mockFirestore.collection('categories').doc(categoryId1).get();
    cat2 = await mockFirestore.collection('categories').doc(categoryId2).get();
    cat3 = await mockFirestore.collection('categories').doc(categoryId3).get();
    cat4 = await mockFirestore.collection('categories').doc(categoryId4).get();
    cat5 = await mockFirestore.collection('categories').doc(categoryId5).get();

    expect(cat1.get('rank'), 1);
    expect(cat2.get('rank'), 2);
    expect(cat3.get('rank'), 3);
    expect(cat4.get('rank'), 4);
    expect(cat5.get('rank'), 0);
  });

  test(
      "Reordering 5 categories from middle ranks update all rank fields correctly",
      () async {
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    const String categoryId3 = "11zz";
    const String categoryId4 = "11aa";
    const String categoryId5 = "11bb";

    var cat1 = await _createCategory(id: categoryId1, is_available: true);
    var cat2 =
        await _createCategory(id: categoryId2, rank: 1, is_available: true);
    var cat3 =
        await _createCategory(id: categoryId3, rank: 2, is_available: true);
    var cat4 =
        await _createCategory(id: categoryId4, rank: 3, is_available: true);
    var cat5 =
        await _createCategory(id: categoryId5, rank: 4, is_available: true);

    expect(cat1.get('rank'), 0);
    expect(cat2.get('rank'), 1);
    expect(cat3.get('rank'), 2);
    expect(cat4.get('rank'), 3);
    expect(cat5.get('rank'), 4);

    await firebaseFunctions.saveCategoryOrder(oldRank: 3, newRank: 1);

    cat1 = await mockFirestore.collection('categories').doc(categoryId1).get();
    cat2 = await mockFirestore.collection('categories').doc(categoryId2).get();
    cat3 = await mockFirestore.collection('categories').doc(categoryId3).get();
    cat4 = await mockFirestore.collection('categories').doc(categoryId4).get();
    cat5 = await mockFirestore.collection('categories').doc(categoryId5).get();

    expect(cat1.get('rank'), 0);
    expect(cat2.get('rank'), 2);
    expect(cat3.get('rank'), 3);
    expect(cat4.get('rank'), 1);
    expect(cat5.get('rank'), 4);
  });

  test(
      "Reordering 5 categories from highest to lowest rank updates all rank fields correctly",
      () async {
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    const String categoryId3 = "11zz";
    const String categoryId4 = "11aa";
    const String categoryId5 = "11bb";

    var cat1 = await _createCategory(id: categoryId1, is_available: true);
    var cat2 =
        await _createCategory(id: categoryId2, rank: 1, is_available: true);
    var cat3 =
        await _createCategory(id: categoryId3, rank: 2, is_available: true);
    var cat4 =
        await _createCategory(id: categoryId4, rank: 3, is_available: true);
    var cat5 =
        await _createCategory(id: categoryId5, rank: 4, is_available: true);

    expect(cat1.get('rank'), 0);
    expect(cat2.get('rank'), 1);
    expect(cat3.get('rank'), 2);
    expect(cat4.get('rank'), 3);
    expect(cat5.get('rank'), 4);

    await firebaseFunctions.saveCategoryOrder(oldRank: 0, newRank: 4);

    cat1 = await mockFirestore.collection('categories').doc(categoryId1).get();
    cat2 = await mockFirestore.collection('categories').doc(categoryId2).get();
    cat3 = await mockFirestore.collection('categories').doc(categoryId3).get();
    cat4 = await mockFirestore.collection('categories').doc(categoryId4).get();
    cat5 = await mockFirestore.collection('categories').doc(categoryId5).get();

    expect(cat1.get('rank'), 4);
    expect(cat2.get('rank'), 0);
    expect(cat3.get('rank'), 1);
    expect(cat4.get('rank'), 2);
    expect(cat5.get('rank'), 3);
  });

  test(
      "Reordering 3 categoryItems from lowest to highest rank updates all rank fields correctly",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";

    await _createCategory(id: categoryId1, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId2);

    var item = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    var item1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId1)
        .get();
    var item2 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId2)
        .get();

    expect(item.get('rank'), 0);
    expect(item1.get('rank'), 1);
    expect(item2.get('rank'), 2);

    await firebaseFunctions.saveCategoryItemOrder(
        categoryId: categoryId1, oldItemIndex: 2, newItemIndex: 0);

    item = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    item1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId1)
        .get();
    item2 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId2)
        .get();

    expect(item.get('rank'), 1);
    expect(item1.get('rank'), 2);
    expect(item2.get('rank'), 0);
  });

  test(
      "Reordering 3 categoryItems from highest to lowest rank updates all rank fields correctly",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";

    await _createCategory(id: categoryId1, is_available: true);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId2);

    var item = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    var item1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId1)
        .get();
    var item2 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId2)
        .get();

    expect(item.get('rank'), 0);
    expect(item1.get('rank'), 1);
    expect(item2.get('rank'), 2);

    await firebaseFunctions.saveCategoryItemOrder(
        categoryId: categoryId1, oldItemIndex: 0, newItemIndex: 2);

    item = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId)
        .get();
    item1 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId1)
        .get();
    item2 = await mockFirestore
        .collection('categoryItems/$categoryId1/items')
        .doc(newItemId2)
        .get();

    expect(item.get('rank'), 2);
    expect(item1.get('rank'), 0);
    expect(item2.get('rank'), 1);
  });

  test(
      "downloadUserCategories converts choice board's data correctly into Categories datatype",
      () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";

    await _createCategory(id: categoryId1, is_available: true);
    await _createCategory(id: categoryId2, is_available: false, rank: 1);

    String newItemId =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId1 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId2,
        itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId2,
        itemId: newItemId2);

    Categories userCategories =
        await firebaseFunctions.downloadUserCategories();

    expect(userCategories.getList().length, 2);
    expect(userCategories.getList()[0].id, categoryId1);
    expect(userCategories.getList()[1].id, categoryId2);
    expect(userCategories.getList()[0].availability, true);
    expect(userCategories.getList()[1].availability, false);
    expect(userCategories.getList()[0].children.length, 1);
    expect(userCategories.getList()[1].children.length, 2);
  });

  test(
      "downloadUserCategories returns an empty Categories datatype if user has no choice boards data",
      () async {
    Categories userCategories =
        await firebaseFunctions.downloadUserCategories();
    expect(userCategories.getList().length, 0);
  });
}
