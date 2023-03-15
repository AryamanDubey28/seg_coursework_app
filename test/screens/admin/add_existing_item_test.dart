import 'dart:io';
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
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/pages/admin/add_choice_board_item.dart';
import 'package:seg_coursework_app/pages/admin/add_existing_item.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/admin_side_menu.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  late String breakfastCategoryId;
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;
  late FirebaseFunctions firebaseFunctions;

  setUpAll(() {
    breakfastCategoryId = testCategories.categories.first.id;

    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    when(mockAuth.currentUser).thenReturn(mockUser);
    firebaseFunctions = FirebaseFunctions(auth: mockAuth, firestore: mockFirestore, storage: mockStorage);
  });

  testWidgets("all elements are present", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AddExistingItem(
              mock: true,
              categoryId: breakfastCategoryId,
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
            ),
          )));
      expect(find.byType(ItemsGrid), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  testWidgets("Tapping on an item saves it as categoryItem", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AddExistingItem(
            mock: true,
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
            categoryId: breakfastCategoryId,
          ))));

      await firebaseFunctions.createItem(name: "testItem", imageUrl: "image.jpg");
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byType(GridTile));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(AdminChoiceBoards), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text("testItem added to category!"), findsOneWidget);
    });
  });

  testWidgets("Tapping on an item that already exists as a categoryItem doesn't save as duplicate", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AddExistingItem(
              mock: true,
              categoryId: breakfastCategoryId,
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
            ),
          )));

      var testId = await firebaseFunctions.createItem(name: "testItem", imageUrl: "image.jpg");
      await firebaseFunctions.createCategoryItem(name: "testItem", imageUrl: "image.jpg", categoryId: breakfastCategoryId, itemId: testId);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(ValueKey(testId)));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(AddExistingItem), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text("testItem already exists in this category!"), findsOneWidget);
    });
  });
}
