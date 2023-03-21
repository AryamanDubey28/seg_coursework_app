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
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/add_existing_item.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/existing_items_grid.dart';

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
    firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);
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

      await firebaseFunctions.createItem(
          name: "testItem", imageUrl: "image.jpg");
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(ExistingItemsGrid), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  testWidgets("Tapping on an item saves it as categoryItem",
      (WidgetTester tester) async {
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

      await firebaseFunctions.createItem(
          name: "testItem", imageUrl: "image.jpg");
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.byType(ImageSquare));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(AdminChoiceBoards), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text("testItem added to category!"), findsOneWidget);
    });
  });

  testWidgets(
      "Tapping on an item that already exists as a categoryItem doesn't save as duplicate",
      (WidgetTester tester) async {
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

      var testId = await firebaseFunctions.createItem(
          name: "testItem", imageUrl: "image.jpg");
      await firebaseFunctions.createCategoryItem(
          name: "testItem",
          imageUrl: "image.jpg",
          categoryId: breakfastCategoryId,
          itemId: testId);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(ValueKey("gridImage0")));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(AddExistingItem), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text("testItem already exists in this category!"),
          findsOneWidget);
    });
  });

  testWidgets('Search bar filters picture grid.', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
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

      await firebaseFunctions.createItem(
          name: "testItem", imageUrl: "image.jpg");
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final searchBar = find.byKey(const ValueKey("searchBar"));

      expect(find.byKey(const ValueKey("gridImage0")), findsOneWidget);

      await tester.tap(searchBar);
      await tester.enterText(searchBar, "notItem");
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byKey(const ValueKey("gridImage0")), findsNothing);

      await tester.enterText(searchBar, "testItem");
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("gridImage0")), findsOneWidget);
    });
  });
}
