import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_create_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_update_functions.dart';

Future<void> main() async {
  late FirebaseUpdateFunctions firebaseUpdateFunctions;
  late FirebaseCreateFunctions firebaseCreateFunctions;
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
    firebaseUpdateFunctions = FirebaseUpdateFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);
    firebaseCreateFunctions = FirebaseCreateFunctions(
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

  test("Reordering non-existent categories returns false", () async {
    expect(
        await firebaseUpdateFunctions.saveCategoryOrder(oldRank: 2, newRank: 0),
        false);
  });

  test("Reordering non-existent categoryItems returns false", () async {
    const String categoryId1 = "00xx";
    await _createCategory(id: categoryId1, is_available: true);
    expect(
        await firebaseUpdateFunctions.saveCategoryItemOrder(
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

    await firebaseUpdateFunctions.saveCategoryOrder(oldRank: 2, newRank: 0);

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

    await firebaseUpdateFunctions.saveCategoryOrder(oldRank: 4, newRank: 0);

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

    await firebaseUpdateFunctions.saveCategoryOrder(oldRank: 3, newRank: 1);

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

    await firebaseUpdateFunctions.saveCategoryOrder(oldRank: 0, newRank: 4);

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

    String newItemId = await firebaseCreateFunctions.createItem(
        name: name, imageUrl: imageUrl);
    String newItemId1 = await firebaseCreateFunctions.createItem(
        name: name, imageUrl: imageUrl);
    String newItemId2 = await firebaseCreateFunctions.createItem(
        name: name, imageUrl: imageUrl);

    await firebaseCreateFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseCreateFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId1);
    await firebaseCreateFunctions.createCategoryItem(
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

    await firebaseUpdateFunctions.saveCategoryItemOrder(
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
        await firebaseCreateFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId1 =
        await firebaseCreateFunctions.createItem(name: name, imageUrl: imageUrl);
    String newItemId2 =
        await firebaseCreateFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseCreateFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseCreateFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId1);
    await firebaseCreateFunctions.createCategoryItem(
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

    await firebaseUpdateFunctions.saveCategoryItemOrder(
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
}
