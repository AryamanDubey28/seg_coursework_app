import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_create_functions.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_delete_functions.dart';

Future<void> main() async {
  late FirebaseDeleteFunctions firebaseDeleteFunctions;
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
    firebaseCreateFunctions = FirebaseCreateFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);
    firebaseDeleteFunctions = FirebaseDeleteFunctions(
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

  test("deleting a categoryItem is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";
    const String categoryId = "00xx";

    String newItemId =
        await firebaseCreateFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseCreateFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId,
        itemId: newItemId);

    DocumentSnapshot newCategoryItem = await mockFirestore
        .collection('categoryItems/$categoryId/items')
        .doc(newItemId)
        .get();
    expect(newCategoryItem.exists, true);

    await firebaseDeleteFunctions.deleteCategoryItem(
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
        await firebaseCreateFunctions.createItem(name: name, imageUrl: imageUrl);

    await firebaseCreateFunctions.createCategoryItem(
        name: name,
        imageUrl: imageUrl,
        categoryId: categoryId1,
        itemId: newItemId);
    await firebaseCreateFunctions.createCategoryItem(
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

    await firebaseDeleteFunctions.deleteCategoryItem(
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

  test("deleting a category is successful", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    String newCategoryId =
        await firebaseCreateFunctions.createCategory(name: name, imageUrl: imageUrl);
    DocumentSnapshot category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.exists, true);

    await firebaseDeleteFunctions.deleteCategory(categoryId: newCategoryId);

    category =
        await mockFirestore.collection('categories').doc(newCategoryId).get();
    expect(category.exists, false);
  });

  test("deleting a non existing category throws exception", () async {
    expect(firebaseDeleteFunctions.deleteCategory(categoryId: "0022xx"),
        throwsA(isA<FirebaseException>()));
  });

  test("deleting a non existing categoryItem throws exception", () async {
    expect(
        firebaseDeleteFunctions.deleteCategoryItem(
            categoryId: "00xx", itemId: "empty"),
        throwsA(isA<FirebaseException>()));
  });
}
