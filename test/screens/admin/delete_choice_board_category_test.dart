import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';

import 'package:seg_coursework_app/pages/admin/delete_choice_board_category.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;
  late DeleteChoiceBoardCategory deleteChoiceBoardCategory;

  // Test values
  const categoryId = '1234';
  const categoryName = 'Category Name';
  const categoryImage = 'Category.jpeg';

  setUpAll(() {
    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    when(mockAuth.currentUser).thenReturn(mockUser);
    deleteChoiceBoardCategory = DeleteChoiceBoardCategory(
        categoryId: categoryId,
        categoryName: categoryName,
        categoryImage: categoryImage,
        auth: mockAuth,
        firestore: mockFirestore,
        storage: mockStorage);
  });

  testWidgets('DeleteChoiceBoardCategory - should show confirmation dialog',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(home: deleteChoiceBoardCategory));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Warning!'), findsOneWidget);
      expect(find.byKey(ValueKey("confirmationAlert")), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
