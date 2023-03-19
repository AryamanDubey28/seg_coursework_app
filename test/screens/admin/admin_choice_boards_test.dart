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
import '../../../lib/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;
  late CategoryItem toastItem;
  late Category breakfastCategory;

  Future<void> _createData() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    await mockFirestore.collection('categories').doc(breakfastCategory.id).set({
      'name': "Breakfast",
      'illustration': "food.jpeg",
      'userId': mockUser.uid,
      'is_available': true,
      'rank': 0
    });

    CollectionReference items = mockFirestore.collection('items');

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

  testWidgets("Category header has all components",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("addCategoryButton")), findsOneWidget);

      expect(find.byKey(ValueKey("categoryHeader-${breakfastCategory.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("categoryImage-${breakfastCategory.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("categoryTitle-${breakfastCategory.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("editCategoryButton-${breakfastCategory.id}")),
          findsOneWidget);
      expect(
          find.byKey(ValueKey("deleteCategoryButton-${breakfastCategory.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("addItemButton-${breakfastCategory.id}")),
          findsOneWidget);
      expect(
          find.byKey(ValueKey("categorySwitchButton-${breakfastCategory.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("categoryDrag")), findsWidgets);
    });
  });

  testWidgets("Category item has all components", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));

      await tester.pumpAndSettle();

      expect(
          find.byKey(ValueKey("categoryItem-${toastItem.id}")), findsOneWidget);
      expect(find.byKey(ValueKey("itemImage-${toastItem.id}")), findsOneWidget);
      expect(find.byKey(ValueKey("itemTitle-${toastItem.id}")), findsOneWidget);
      expect(find.byKey(ValueKey("editItemButton-${toastItem.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("itemSwitchButton-${toastItem.id}")),
          findsOneWidget);
      expect(find.byKey(ValueKey("itemDrag")), findsWidgets);
    });
  });

  testWidgets("Add item button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));

      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(ValueKey("addItemButton-${breakfastCategory.id}")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("addItemHero-${breakfastCategory.id}")),
          findsOneWidget);
    });
  });

  testWidgets("Edit item button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(
          find.byKey(ValueKey("editItemHero-${toastItem.id}")), findsOneWidget);
    });
  });

  testWidgets("Delete item button shows confirmation alert",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
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

  testWidgets("Delete item alert has two buttons", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(ValueKey("deleteItemButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("cancelItemDelete")), findsOneWidget);
      expect(find.byKey(ValueKey("confirmItemDelete")), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
    });
  });

  testWidgets("Cancel deleting item hides alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
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

      await tester.tap(find.byKey(ValueKey("cancelItemDelete")));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets("Confirm deleting item hides alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
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

      await tester.tap(find.byKey(ValueKey("confirmItemDelete")));
      await tester.pump();

      expect(find.byType(AdminChoiceBoard), findsWidgets);
    });
  });

  testWidgets("Valid category item switch button works as expected",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();
      await _createData();

      await tester
          .tap(find.byKey(ValueKey("itemSwitchButton-${toastItem.id}")));
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoard), findsOneWidget);
    });
  });

  testWidgets("Valid category item switch button works as expected",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: AdminChoiceBoard(
                  testCategories: testCategories,
                  auth: mockAuth,
                  firestore: mockFirestore,
                  storage: mockStorage,
                  mock: true))));
      await tester.pumpAndSettle();
      await _createData();

      await tester.tap(
          find.byKey(ValueKey("categorySwitchButton-${breakfastCategory.id}")));
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoard), findsOneWidget);
    });
  });
}
