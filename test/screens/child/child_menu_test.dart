import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/child/child_main_menu.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_row.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/category/category_image_row.dart';
import 'package:seg_coursework_app/widgets/category/category_title.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import '../auth/edit_account_widget_test.dart';

// Test ensures that column of rows (categories) is displayed on screen

late FirebaseAuth mockAuth;
late FirebaseFirestore mockFirestore;
late FirebaseStorage mockStorage;
late MockUser mockUser;
late CategoryItem toastItem;
late Category breakfastCategory;
late Categories images_list_from_category;

void main() {
  late Auth authenticationHelper;
  const _email = 'ilyas@yopmail.com';
  const _uid = 'sampleUid';
  const _displayName = 'ilyas';
  const _password = 'Test@123';
  final _mockUser = MyMockUser(
    uid: _uid,
    email: _email,
    displayName: _displayName,
  );

  setUpAll(() async {
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockUser = MyMockUser(email: _email, uid: _uid, displayName: _displayName);
    when(mockAuth.currentUser).thenReturn(mockUser);

    images_list_from_category = testCategories;
  });

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

  setUpAll(() async {
    final MockFirebaseAuth _mockAuth = MockFirebaseAuth();
    final MockFirebaseStorage _mockStorage = MockFirebaseStorage();
    final FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: _mockAuth,
        firestore: fakeFirebaseFirestore,
        storage: _mockStorage);
    authenticationHelper =
        Auth(auth: _mockAuth, firestore: fakeFirebaseFirestore);
    toastItem = myTestCategories.getList().first.items.first;
    breakfastCategory = myTestCategories.getList().first;
    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    when(mockAuth.currentUser).thenReturn(mockUser);
  });

  testWidgets('Test column (with rows) is present', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: ChildMainMenu(
              mock: true,
              auth: MockFirebaseAuth(),
              firebaseFirestore: FakeFirebaseFirestore(),
              storage: MockFirebaseStorage(),
              testCategories: testCategories,
            ),
          )));
      await tester.pumpAndSettle();
      expect(find.byType(ChildMainMenu), findsWidgets);
      expect(find.byType(ChildMenuCategoryRow), findsWidgets);
      expect(find.byType(ImageSquare), findsWidgets);
      expect(find.byType(CategoryTitle), findsWidgets);
      expect(find.byType(ChildMenuCategoryRow), findsWidgets);
    });
  });
  testWidgets('Test tappable row directs to new screen', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: ChildMenuCategoryRow(
                category: testCategories.getList()[0],
                categoryItems: testCategories.getList()[0].items),
          )));

      await tester.tap(find.byType(ChildMenuCategoryRow));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);
      expect(find.byKey(const ValueKey("backButton")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryTitle")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsWidgets);
    });
  });

  testWidgets("List of Clickable images show on Child UI", (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: ChildMainMenu(
            mock: true,
            testCategories: testCategories,
            auth: mockAuth,
            firebaseFirestore: mockFirestore,
            storage: MockFirebaseStorage(),
          ))));
      await tester.pumpAndSettle();
      expect(find.byType(ChildMenuCategoryRow), findsWidgets);
    });
  });

  testWidgets(
      "Test category with less than or equal to 1 entries does not display on screen",
      (tester) async {
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
            home: ChildMainMenu(
          mock: true,
          auth: mockAuth,
          firebaseFirestore: mockFirestore,
          testCategories: Categories(categories: []),
          storage: MockFirebaseStorage(),
        ))));

    expect(find.byType(ChildMenuCategoryRow), findsNothing);
  });

  // testWidgets("ChildMainMenu makes a database request every 5-6 seconds",
  //     (tester) async {
  //   await tester.pumpWidget(ThemeProvider(
  //       themeNotifier: CustomTheme(),
  //       child: MaterialApp(
  //           home: ChildMainMenu(
  //         mock: true,
  //         auth: mockAuth,
  //         firebaseFirestore: mockFirestore,
  //       ))));
  //   int initialValue = ChildMainMenu.customizableColumnRequestCounter;
  //   await tester.pump(Duration(seconds: 5));
  //   int latestValue = ChildMainMenu.customizableColumnRequestCounter;
  //   bool greater = latestValue > initialValue;
  //   expect(greater, true); //value has increased
  // });

  testWidgets("Child logging out and entering PIN routes to Admin page",
      (tester) async {
    final myMockFirestore = MyMockFirebaseFirestore(userId: _uid);
    final myMockAuth = MyMockFirebaseAuth(mockUser: _mockUser);
    myMockFirestore.saveDocument('userPins');
    final authHelper =
        Auth(auth: myMockAuth, firestore: myMockFirestore, mock: true);
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
            home: ChildMainMenu(
          mock: true,
          auth: myMockAuth,
          firebaseFirestore: myMockFirestore,
          storage: MockFirebaseStorage(),
          testCategories: testCategories,
        ))));
    await authHelper.signIn(_email, _password);
    String currentPin = await authHelper.getCurrentUserPIN();
    await tester.pumpAndSettle();

    final Finder logoutButton = find.byKey(Key("logoutButton"));
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    //dialog shows up
    final Finder passwordTextField = find.byKey(Key("logoutButtonTextField"));

    await tester.tap(passwordTextField);
    await tester.pumpAndSettle();
    await tester.enterText(passwordTextField, currentPin);
    await tester.pumpAndSettle();

    final Finder submitButton = find.byKey(Key("submitButton"));
    await tester.tap(submitButton);
    // await tester.pumpAndSettle();
    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work for some reason
      await tester.pump(Duration(seconds: 1));
    }
    expect(find.byType(AdminChoiceBoards), findsOneWidget);
  });

  testWidgets("Child logging out doesn't work if PIN is incorrect",
      (tester) async {
    final myMockFirestore = MyMockFirebaseFirestore(userId: _uid);
    final myMockAuth = MyMockFirebaseAuth(mockUser: _mockUser);
    myMockFirestore.saveDocument('userPins');
    final authHelper =
        Auth(auth: myMockAuth, firestore: myMockFirestore, mock: true);
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
            home: ChildMainMenu(
          mock: true,
          auth: myMockAuth,
          firebaseFirestore: myMockFirestore,
          storage: MockFirebaseStorage(),
          testCategories: testCategories,
        ))));
    await authHelper.signIn(_email, _password);
    String currentPin = await authHelper.getCurrentUserPIN();
    await tester.pumpAndSettle();

    final Finder logoutButton = find.byKey(Key("logoutButton"));
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Dialog to enter PIN appears.
    final Finder passwordTextField = find.byKey(Key("logoutButtonTextField"));

    await tester.tap(passwordTextField);
    await tester.pumpAndSettle();
    await tester.enterText(passwordTextField, "9999");
    await tester.pumpAndSettle();

    final Finder submitButton = find.byKey(Key("submitButton"));
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.byType(AdminChoiceBoards), findsNothing);
  });
}
