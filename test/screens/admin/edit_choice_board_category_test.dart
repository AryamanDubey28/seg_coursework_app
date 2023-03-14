import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/pages/admin/edit_choice_board_category.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  late Category breakfastCategory;
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;

  Future<void> createData() async {
    await mockFirestore.collection('categories').doc(breakfastCategory.id).set({
      'name': "Breakfast",
      'illustration': "food.jpeg",
      'userId': mockUser.uid,
      'rank': 0
    });
  }

  setUpAll(() {
    breakfastCategory = testCategories.getList().first;

    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    when(mockAuth.currentUser).thenReturn(mockUser);
  });

  testWidgets("all elements are present", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardCategory(
            mock: true,
            categoryId: breakfastCategory.id,
            categoryImageUrl: "food.jpeg",
            categoryName: "food.jpeg",
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      expect(find.byKey(const ValueKey("categoryImageCard")), findsOneWidget);
      expect(find.byKey(const ValueKey("instructionsText")), findsOneWidget);
      expect(
          find.byKey(const ValueKey("pickImageFromGallery")), findsOneWidget);
      expect(find.byKey(const ValueKey("takeImageWithCamera")), findsOneWidget);
      expect(find.byKey(const ValueKey("categoryNameField")), findsOneWidget);
      expect(find.byKey(const ValueKey("editCategoryButton")), findsOneWidget);
    });
  });

  testWidgets("making no edits takes user to choice board page",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardCategory(
            mock: true,
            categoryId: breakfastCategory.id,
            categoryImageUrl: "food.jpeg",
            categoryName: "food.jpeg",
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      await createData();

      await tester.tap(find.byKey(ValueKey("editCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("changing only name is successful", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardCategory(
            mock: true,
            categoryId: breakfastCategory.id,
            categoryImageUrl: "food.jpeg",
            categoryName: "food",
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      await createData();

      final nameField = find.byKey(ValueKey("categoryNameField"));
      await tester.enterText(nameField, "Lunch");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("editing a category that doesn't exist shows error",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardCategory(
            mock: true,
            categoryId: breakfastCategory.id,
            categoryImageUrl: "food.jpeg",
            categoryName: "food",
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      final nameField = find.byKey(ValueKey("categoryNameField"));
      await tester.enterText(nameField, "Dinner");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
