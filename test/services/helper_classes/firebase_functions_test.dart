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
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';

Future<void> main() async {
  late FirebaseFunctions firebaseFunctions;
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockUser = MockUser(uid: "user1");
    firebaseFunctions = FirebaseFunctions(auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    when(mockAuth.currentUser).thenReturn(mockUser);
  });
  tearDown(() async {
    mockFirestore = FakeFirebaseFirestore();
  });

  Future<void> _createCategory({required String id}) {
    return mockFirestore.collection('categories').doc(id).set({'name': "Drinks", 'illustration': "drink.jpeg", 'userId': mockUser.uid, 'rank': 0});
  }

  test("create item is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    expect(newItemId, isA<String>());
    DocumentSnapshot item = await mockFirestore.collection('items').doc(newItemId).get();
    expect(item.get('name'), name);
    expect(item.get('illustration'), imageUrl);
    expect(item.get('userId'), "user1");
    expect(item.get('is_available'), true);
  });

  test("create items gives unique ids", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId1 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    expect(newItemId1, isNot(newItemId2));
  });

  test("user can create more than one item", () async {
    const String name1 = "Water";
    const String imageUrl1 = "Nova-water.jpeg";
    const String name2 = "Apple juice";
    const String imageUrl2 = "Nova-Juice.jpeg";

    String newItemId1 = await firebaseFunctions.createItem(name: name1, imageUrl: imageUrl1);
    String newItemId2 = await firebaseFunctions.createItem(name: name2, imageUrl: imageUrl2);

    DocumentSnapshot item1 = await mockFirestore.collection('items').doc(newItemId1).get();
    DocumentSnapshot item2 = await mockFirestore.collection('items').doc(newItemId2).get();

    final QuerySnapshot itemsQuerySnapshot = await mockFirestore.collection('items').get();

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

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();

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

    String newItemId1 = await firebaseFunctions.createItem(name: name1, imageUrl: imageUrl1);
    String newItemId2 = await firebaseFunctions.createItem(name: name2, imageUrl: imageUrl2);

    await firebaseFunctions.createCategoryItem(name: name1, imageUrl: imageUrl1, categoryId: categoryId, itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(name: name2, imageUrl: imageUrl2, categoryId: categoryId, itemId: newItemId2);

    DocumentSnapshot newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId1).get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId2).get();

    final QuerySnapshot categoryItemsQuerySnapshot = await mockFirestore.collection('categoryItems/$categoryId/items').get();

    expect(categoryItemsQuerySnapshot.size, 2);
    expect(newCategoryItem1.get('name'), name1);
    expect(newCategoryItem2.get('name'), name2);
    expect(newCategoryItem1.get('illustration'), imageUrl1);
    expect(newCategoryItem2.get('illustration'), imageUrl2);
    expect(newCategoryItem1.get('userId'), "user1");
    expect(newCategoryItem2.get('userId'), "user1");
  });

  test("new categoryItem rank is one more than highest rank (using getNewCategoryItemRank)", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId2);

    DocumentSnapshot newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId1).get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId2).get();

    expect(newCategoryItem1.get('rank'), 0);
    expect(newCategoryItem2.get('rank'), 1);
  });

  test("update item name edits the item's name successfully", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    DocumentSnapshot item = await mockFirestore.collection('items').doc(newItemId).get();

    expect(item.get('name'), name);
    await firebaseFunctions.updateCategoryName(itemId: newItemId, newName: "Nova Water");

    item = await mockFirestore.collection('items').doc(newItemId).get();
    expect(item.get('name'), "Nova Water");
  });

  test("updating the name of an item that doesn't exist throws an exception", () async {
    expect(firebaseFunctions.updateCategoryName(itemId: "doesn't exist", newName: "Nove Water"), throwsA(isInstanceOf<FirebaseException>()));
  });

  test("update categoryItem name edits the name successfully (1 categoryItem)", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";
    await _createCategory(id: categoryId);

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();

    expect(newCategoryItem.get('name'), name);
    await firebaseFunctions.updateCategoryItemsName(itemId: newItemId, newName: "Nova Water");

    newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();
    expect(newCategoryItem.get('name'), "Nova Water");
  });

  test("update categoryItem name edits the name successfully (2 categoryItems in 2 categories)", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    await _createCategory(id: categoryId1);
    await _createCategory(id: categoryId2);

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId1, itemId: newItemId);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId2, itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId1/items').doc(newItemId).get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId2/items').doc(newItemId).get();

    expect(newCategoryItem1.get('name'), name);
    expect(newCategoryItem2.get('name'), name);
    await firebaseFunctions.updateCategoryItemsName(itemId: newItemId, newName: "Nova Water");

    newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId1/items').doc(newItemId).get();
    newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId2/items').doc(newItemId).get();

    expect(newCategoryItem1.get('name'), "Nova Water");
    expect(newCategoryItem2.get('name'), "Nova Water");
  });

  test("updating the name of a categoryItem without having categories throws an exception", () async {
    expect(firebaseFunctions.updateCategoryItemsName(itemId: "doesn't exist", newName: "Nova Water"), throwsA(isInstanceOf<FirebaseException>()));
  });

  test("updating the name of a categoryItem that doesn't exist (when categories exist) does nothing", () async {
    await _createCategory(id: "00xx");
    expect(await firebaseFunctions.updateCategoryItemsName(itemId: "doesn't exist", newName: "Nova Water"), null);
  });

  test("updating the name of a categoryItem in a deleted category throws an exception", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId);

    expect(firebaseFunctions.updateCategoryItemsName(itemId: newItemId, newName: "Nova Water"), throwsA(isInstanceOf<FirebaseException>()));
  });

  test("Uploading image to cloud is successful", () async {
    String? imageUrl = await firebaseFunctions.uploadImageToCloud(image: File("assets/test_image.png"), name: "Water");

    expect(imageUrl, isA<String>());
    expect(mockStorage.refFromURL(imageUrl!), isNotNull);
  });

  test("Deleting image from cloud is successful", () async {
    String? imageUrl = await firebaseFunctions.uploadImageToCloud(image: File("assets/test_image.png"), name: "Water");

    expect(mockStorage.refFromURL(imageUrl!), isNotNull);
    await firebaseFunctions.deleteImageFromCloud(imageUrl: imageUrl);

    expect(mockStorage.refFromURL(imageUrl), isNotNull);
  });

  test("update item image edits the item's image successfully", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    DocumentSnapshot item = await mockFirestore.collection('items').doc(newItemId).get();

    expect(item.get('illustration'), imageUrl);
    await firebaseFunctions.updateItemImage(itemId: newItemId, newImageUrl: "Hana-water.jpeg");

    item = await mockFirestore.collection('items').doc(newItemId).get();
    expect(item.get('illustration'), "Hana-water.jpeg");
  });

  test("updating the image of an item that doesn't exist throws an exception", () async {
    expect(firebaseFunctions.updateItemImage(itemId: "doesn't exist", newImageUrl: "Hana-water.jpeg"), throwsA(isInstanceOf<FirebaseException>()));
  });

  test("update categoryItem image edits the image successfully (1 categoryItem)", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";
    await _createCategory(id: categoryId);

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();

    expect(newCategoryItem.get('illustration'), imageUrl);
    await firebaseFunctions.updateCategoryItemsImage(itemId: newItemId, newImageUrl: "Hana-water.jpeg");

    newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();
    expect(newCategoryItem.get('illustration'), "Hana-water.jpeg");
  });

  test("update categoryItem image edits the image successfully (2 categoryItems in 2 categories)", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";
    await _createCategory(id: categoryId1);
    await _createCategory(id: categoryId2);

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId1, itemId: newItemId);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId2, itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId1/items').doc(newItemId).get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId2/items').doc(newItemId).get();

    expect(newCategoryItem1.get('illustration'), imageUrl);
    expect(newCategoryItem2.get('illustration'), imageUrl);
    await firebaseFunctions.updateCategoryItemsImage(itemId: newItemId, newImageUrl: "Hana-water.jpeg");

    newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId1/items').doc(newItemId).get();
    newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId2/items').doc(newItemId).get();

    expect(newCategoryItem1.get('illustration'), "Hana-water.jpeg");
    expect(newCategoryItem2.get('illustration'), "Hana-water.jpeg");
  });

  test("updating the image of a categoryItem without having categories throws an exception", () async {
    expect(firebaseFunctions.updateCategoryItemsImage(itemId: "doesn't exist", newImageUrl: "Hana-water.jpeg"), throwsA(isInstanceOf<FirebaseException>()));
  });

  test("updating the image of a categoryItem that doesn't exist (when categories exist) does nothing", () async {
    await _createCategory(id: "00xx");
    expect(await firebaseFunctions.updateCategoryItemsImage(itemId: "doesn't exist", newImageUrl: "Hana-water.jpeg"), null);
  });

  test("updating the image of a categoryItem in a deleted category throws an exception", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId);

    expect(firebaseFunctions.updateCategoryItemsImage(itemId: newItemId, newImageUrl: "Hana-water.jpeg"), throwsA(isInstanceOf<FirebaseException>()));
  });

  test("deleting a categoryItem is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();
    expect(newCategoryItem.exists, true);

    await firebaseFunctions.deleteCategoryItem(categoryId: categoryId, itemId: newItemId);

    newCategoryItem = await mockFirestore.collection('categoryItems/$categoryId/items').doc(newItemId).get();
    expect(newCategoryItem.exists, false);
  });

  test("deleting a categoryItem doesn't delete other categoryItems in other categories with same itemId", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId1 = "00xx";
    const String categoryId2 = "11yy";

    String newItemId = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId1, itemId: newItemId);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId2, itemId: newItemId);

    DocumentSnapshot newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId1/items').doc(newItemId).get();
    DocumentSnapshot newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId2/items').doc(newItemId).get();

    expect(newCategoryItem1.exists, true);
    expect(newCategoryItem2.exists, true);

    await firebaseFunctions.deleteCategoryItem(categoryId: categoryId1, itemId: newItemId);

    newCategoryItem1 = await mockFirestore.collection('categoryItems/$categoryId1/items').doc(newItemId).get();
    newCategoryItem2 = await mockFirestore.collection('categoryItems/$categoryId2/items').doc(newItemId).get();

    expect(newCategoryItem1.exists, false);
    expect(newCategoryItem2.exists, true);
  });

  test("deleting a non existing categoryItem throws exception", () async {
    expect(firebaseFunctions.deleteCategoryItem(categoryId: "00xx", itemId: "empty"), throwsA(isA<FirebaseException>()));
  });

  test("getCategoryItemRank returns correct rank", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId2);

    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId1), 0);
    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId2), 1);
  });

  test("getCategoryItemRank throws exception for non existing categoryItems", () async {
    expect(firebaseFunctions.getCategoryItemRank(categoryId: "00xx", itemId: "empty"), throwsA(isA<FirebaseException>()));
  });

  test("updateCategoryRanks decrements all ranks of categoryItems higher than given rank", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId3 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId2);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId3);

    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId2), 1);
    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId3), 2);

    await firebaseFunctions.updateCategoryRanks(categoryId: categoryId, removedRank: await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId1));
    await firebaseFunctions.deleteCategoryItem(categoryId: categoryId, itemId: newItemId1); // delete isn't necessary

    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId2), 0);
    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId3), 1);
  });

  test("updateCategoryRanks does nothing if the deleted categoryItem had highest rank", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId1 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId3 = await firebaseFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId1);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId2);
    await firebaseFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: categoryId, itemId: newItemId3);

    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId1), 0);
    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId2), 1);

    await firebaseFunctions.updateCategoryRanks(categoryId: categoryId, removedRank: await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId3));
    await firebaseFunctions.deleteCategoryItem(categoryId: categoryId, itemId: newItemId3); // delete isn't necessary

    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId1), 0);
    expect(await firebaseFunctions.getCategoryItemRank(categoryId: categoryId, itemId: newItemId2), 1);
  });

  test("updateCategoryRanks does nothing if given non existing categoryId", () async {
    expect(await firebaseFunctions.updateCategoryRanks(categoryId: "00xx", removedRank: 1), null);
  });
}
