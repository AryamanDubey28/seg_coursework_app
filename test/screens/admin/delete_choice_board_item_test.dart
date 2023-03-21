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
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;
  late CategoryItem toastItem;
  late Category breakfastCategory;
  late FirebaseFunctions firebaseFunctions;

  Future<void> _createData() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    await mockFirestore.collection('categories').doc(breakfastCategory.id).set({
      'title': breakfastCategory.title,
      'illustration': breakfastCategory.imageUrl,
      'userId': mockUser.uid,
      'is_available': true,
      'rank': 0
    });

    CollectionReference items = mockFirestore.collection('items');

    await firebaseFunctions.uploadImageToCloud(
        image: File("assets/test_image.png"),
        name: toastItem.name,
        overrideUniqueName: true);

    await items.doc(toastItem.id).set({
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
    firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);
  });

  testWidgets("Delete item button shows confirmation alert",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("deleteItemAlert-${toastItem.id}")),
          findsOneWidget);
    });
  });

  testWidgets("Delete item alert has three buttons",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("cancelItemDelete")), findsOneWidget);
      expect(find.byKey(const ValueKey("confirmItemDelete")), findsOneWidget);
      expect(
          find.byKey(const ValueKey("ItemDeleteEverywhere")), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(3));
    });
  });

  testWidgets("Cancel deleting item hides alert", (WidgetTester tester) async {
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("cancelItemDelete")));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets("Confirm deleting item hides alert", (WidgetTester tester) async {
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("confirmItemDelete")));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets("Confirm deleting item deletes only catgeoryItem",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("confirmItemDelete")));
      await tester.pumpAndSettle();

      expect(await firebaseFunctions.itemExists(itemId: toastItem.id), true);
      expect(
          await firebaseFunctions.categoryItemExists(
              categoryId: breakfastCategory.id, itemId: toastItem.id),
          false);
      expect(mockStorage.refFromURL(toastItem.imageUrl), isNotNull);
    });
  });

  testWidgets("Delete everywhere button shows second confirmation alert",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("deleteItemAlert-${toastItem.id}")),
          findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("ItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("deleteItemEverywhereAlert-${toastItem.id}")),
          findsOneWidget);
      expect(find.byType(AlertDialog), findsNWidgets(2));
    });
  });

  testWidgets(
      "Cancel delete everywhere button goes back to first confirmation alert",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("deleteItemAlert-${toastItem.id}")),
          findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("ItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("deleteItemEverywhereAlert-${toastItem.id}")),
          findsOneWidget);
      expect(find.byType(AlertDialog), findsNWidgets(2));

      await tester
          .tap(find.byKey(const ValueKey("cancelItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets("Confirm delete everywhere button hides alerts",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("ItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(const ValueKey("confirmItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets(
      "Confirm deleting item everywhere deletes item and all categoryItems",
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

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("ItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(const ValueKey("confirmItemDeleteEverywhere")));
      await tester.pumpAndSettle();

      expect(await firebaseFunctions.itemExists(itemId: toastItem.id), false);
      expect(
          await firebaseFunctions.categoryItemExists(
              categoryId: breakfastCategory.id, itemId: toastItem.id),
          false);
      expect(mockStorage.refFromURL(toastItem.imageUrl), isNotNull);
    });
  });
}
