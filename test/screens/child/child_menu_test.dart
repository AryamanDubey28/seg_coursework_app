import 'dart:math';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_row.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/category_image.dart';
import 'package:seg_coursework_app/widgets/category_row.dart';
import 'package:seg_coursework_app/widgets/category_title.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// Test ensures that column of rows (categories) is displayed on screen

void main() {
  late Auth auth;
  const _email = 'ilyas@yopmail.com';
  const _uid = 'sampleUid';
  const _displayName = 'ilyas';
  const _password = 'Test@123';
  final _mockUser = MockUser(
    uid: _uid,
    email: _email,
    displayName: _displayName,
  );

  setUpAll(() async {
    final MockFirebaseAuth _mockAuth = MockFirebaseAuth();
    final MockFirebaseStorage _mockStorage = MockFirebaseStorage();
    final FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: _mockAuth,
        firestore: fakeFirebaseFirestore,
        storage: _mockStorage);
    auth = Auth(auth: _mockAuth);
  });
  testWidgets('Test column (with rows) is present', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: CustomizableColumn(
              mock: true,
            ),
          )));

      expect(find.byType(CustomizableColumn), findsWidgets);
      expect(find.byType(CustomizableRow), findsWidgets);
      expect(find.byType(CategoryImage), findsWidgets);
      expect(find.byType(CategoryTitle), findsWidgets);
      expect(find.byType(CategoryImageRow), findsWidgets);
    });
  });

  testWidgets('Test tappable row directs to new screen', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: CustomizableRow(
                categoryTitle: "Title", imagePreviews: imageRow),
          )));

      await tester.tap(find.byType(CustomizableRow));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);
      expect(find.byKey(const ValueKey("backButton")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryTitle")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsWidgets);
    });
  });

  testWidgets(
      "Test category with less than or equal to 1 entries does not display on screen",
      (tester) async {
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
            home: CustomizableColumn(
          mock: true,
          testList:
              test_list_clickable_images_zero, //special list containing 0 category items
        ))));

    expect(find.byType(CustomizableRow), findsNothing);
  });

  testWidgets("CustomizableColumn makes a database request every 5-6 seconds",
      (tester) async {
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
            home: CustomizableColumn(
          mock: true,
        ))));
    int initialValue = CustomizableColumn.customizableColumnRequestCounter;
    print("initalVal = $initialValue");
    await tester.pump(Duration(seconds: 5));
    int latestValue = CustomizableColumn.customizableColumnRequestCounter;
    print("new val = $latestValue");
    bool greater = latestValue > initialValue;
    print("greater? $greater");
    expect(greater, true); //value has increased
  });
}
