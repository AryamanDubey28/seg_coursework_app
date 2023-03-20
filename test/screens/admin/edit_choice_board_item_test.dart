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
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/pages/admin/edit_choice_board_item.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  late CategoryItem toastItem;
  late Category breakfastCategory;
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;

  Future<void> _createData() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    await mockFirestore.collection('categories').doc(breakfastCategory.id).set({
      'name': "Breakfast",
      'illustration': "https://food.jpeg",
      'userId': mockUser.uid,
      'is_available': true,
      'rank': 0
    });

    CollectionReference items = mockFirestore.collection('items');

    await firebaseFunctions.uploadImageToCloud(
        image: File("assets/test_image.png"),
        name: toastItem.name,
        overrideUniqueName: true);

    items.doc(toastItem.id).set({
      'name': toastItem.name,
      'illustration': toastItem.imageUrl,
      'is_available': true,
      'userId': mockUser.uid
    });

    await firebaseFunctions.createCategoryItem(
        name: toastItem.name,
        imageUrl: toastItem.imageUrl,
        categoryId: breakfastCategory.id,
        itemId: toastItem.id);
  }

  setUpAll(() {
    toastItem = testCategories.getList().first.items.first;
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
              home: EditChoiceBoardItem(
            itemId: toastItem.id,
            itemImageUrl: toastItem.imageUrl,
            itemName: toastItem.imageUrl,
            mock: true,
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      expect(find.byKey(const ValueKey("itemImageCard")), findsOneWidget);
      expect(find.byKey(const ValueKey("instructionsText")), findsOneWidget);
      expect(
          find.byKey(const ValueKey("pickImageFromGallery")), findsOneWidget);
      expect(find.byKey(const ValueKey("takeImageWithCamera")), findsOneWidget);
      expect(find.byKey(const ValueKey("itemNameField")), findsOneWidget);
      expect(find.byKey(const ValueKey("editItemButton")), findsOneWidget);
    });
  });

  testWidgets("making no edits takes user to choice board page",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardItem(
            itemId: toastItem.id,
            itemImageUrl: toastItem.imageUrl,
            itemName: toastItem.imageUrl,
            mock: true,
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      await _createData();

      await tester.tap(find.byKey(ValueKey("editItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("changing only name is successful", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardItem(
            itemId: toastItem.id,
            itemImageUrl: toastItem.imageUrl,
            itemName: toastItem.imageUrl,
            mock: true,
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      await _createData();

      final nameField = find.byKey(ValueKey("itemNameField"));
      await tester.enterText(nameField, "Eggs");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("changing both name and image is successful",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardItem(
            itemId: toastItem.id,
            itemImageUrl: toastItem.imageUrl,
            itemName: toastItem.imageUrl,
            mock: true,
            newPreSelectedImage: File("assets/test_image.png"),
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      await _createData();

      final nameField = find.byKey(ValueKey("itemNameField"));
      await tester.enterText(nameField, "Eggs");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("changing only image is successful", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardItem(
            itemId: toastItem.id,
            itemImageUrl: toastItem.imageUrl,
            itemName: toastItem.imageUrl,
            mock: true,
            newPreSelectedImage: File("assets/test_image.png"),
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      await _createData();

      await tester.tap(find.byKey(ValueKey("editItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("editing an item that doesn't exist shows error",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditChoiceBoardItem(
            itemId: toastItem.id,
            itemImageUrl: toastItem.imageUrl,
            itemName: toastItem.imageUrl,
            mock: true,
            auth: mockAuth,
            firestore: mockFirestore,
            storage: mockStorage,
          ))));

      final nameField = find.byKey(ValueKey("itemNameField"));
      await tester.enterText(nameField, "Eggs");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
