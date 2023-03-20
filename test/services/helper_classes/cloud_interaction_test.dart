import 'dart:io';
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
}
