import 'dart:io';
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
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/delete_choice_board_category.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late Category breakfastCategory;
  late MockUser mockUser;
  late DeleteChoiceBoardCategory deleteChoiceBoardCategory;

  Future<void> _createData() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    await firebaseFunctions.uploadImageToCloud(
        image: File("assets/test_image.png"),
        name: breakfastCategory.title,
        overrideUniqueName: true);

    await mockFirestore.collection('categories').doc(breakfastCategory.id).set({
      'title': breakfastCategory.title,
      'illustration': breakfastCategory.imageUrl,
      'userId': mockUser.uid,
      'is_available': true,
      'rank': 0
    });
  }

  setUpAll(() {
    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    breakfastCategory = testCategories.getList().first;
    when(mockAuth.currentUser).thenReturn(mockUser);
  });

  testWidgets(
      "Delete category button (from choice boards page) shows confirmation alert",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoards(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();

      await tester.tap(
          find.byKey(ValueKey("deleteCategoryButton-${breakfastCategory.id}")));
      await tester.pumpAndSettle();

      expect(
          find.byKey(ValueKey("deleteCategoryAlert-${breakfastCategory.id}")),
          findsOneWidget);
    });
  });

  testWidgets("Cancel deleting category hides alert (from choice boards page)",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoards(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();
      await _createData();

      await tester.tap(
          find.byKey(ValueKey("deleteCategoryButton-${breakfastCategory.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("cancelCategoryDelete")));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets("Confirm deleting category hides alert (from choice boards page)",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoards(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();

      await _createData();

      await tester.tap(
          find.byKey(ValueKey("deleteCategoryButton-${breakfastCategory.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("confirmCategoryDelete")));
      await tester.pump();

      expect(find.byType(AdminChoiceBoards), findsWidgets);
    });
  });

  testWidgets('delete category alert has all contents',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: DeleteChoiceBoardCategory(
              categoryId: breakfastCategory.id,
              categoryName: breakfastCategory.title,
              categoryImage: breakfastCategory.imageUrl,
              mock: true,
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage)));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Warning!'), findsOneWidget);
      expect(
          find.byKey(ValueKey("deleteCategoryAlert-${breakfastCategory.id}")),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
