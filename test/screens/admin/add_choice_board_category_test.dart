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
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/pages/admin/add_choice_board_category.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;

  setUpAll(() {
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
            home: AddChoiceBoardCategory(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
            ),
          )));

      expect(find.byKey(const ValueKey("categoryImageCard")), findsOneWidget);
      expect(find.byKey(const ValueKey("instructionsText")), findsOneWidget);
      expect(find.byKey(const ValueKey("pickImageFromGallery")), findsOneWidget);
      expect(find.byKey(const ValueKey("takeImageWithCamera")), findsOneWidget);
      expect(find.byKey(const ValueKey("categoryNameField")), findsOneWidget);
      expect(find.byKey(const ValueKey("createCategoryButton")), findsOneWidget);
    });
  });

  testWidgets("name and image missing shows alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AddChoiceBoardCategory(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
            ),
          )));

      await tester.tap(find.byKey(ValueKey("createCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets("only image missing shows alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AddChoiceBoardCategory(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
            ),
          )));

      final nameField = find.byKey(ValueKey("categoryNameField"));
      await tester.enterText(nameField, "Category");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("createCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets("only name missing shows alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AddChoiceBoardCategory(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
            ),
          )));

      await tester.tap(find.byKey(ValueKey("createCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets("successful category creation takes user to choice boards page", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AddChoiceBoardCategory(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              preSelectedImage: File("assets/test_image.png"),
            ),
          )));

      final nameField = find.byKey(ValueKey("categoryNameField"));
      await tester.enterText(nameField, "Breakfast");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("createCategoryButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });
}
