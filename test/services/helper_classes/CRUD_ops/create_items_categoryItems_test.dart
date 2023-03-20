import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
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
}
