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