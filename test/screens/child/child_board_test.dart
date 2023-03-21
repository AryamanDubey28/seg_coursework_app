import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/pages/child/category_details_display.dart';
import 'package:seg_coursework_app/pages/child/child_main_menu.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

import '../admin/choice_board/delete_choice_board_category_test.dart';
import '../auth/forgot_password_test.dart';

void main() {
  testWidgets("Category has all components", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: ChildBoards(
              categoryTitle: "",
              categoryImage:
                  "https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cmFuZG9tfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
              images: [],
            ),
          )));

      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);

      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);

      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);

      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsOneWidget);

      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsOneWidget);

      expect(find.byKey(const ValueKey("backButton")), findsWidgets);

      expect(find.byKey(const ValueKey("categoryTitle")), findsOneWidget);
    });
  });

  testWidgets(
      'ChildBoards navigates back to the parent menu when the back button is pressed',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: ChildMainMenu(
              mock: true,
              auth: MockFirebaseAuth(),
              firebaseFirestore: MockFirebaseFirestore(),
              storage: MockFirebaseStorage(),
              testCategories: testCategories,
            ),
          )));

      await tester.pumpAndSettle();
      // Verify that the ChildMainMenu page is displayed
      expect(find.byType(ChildMainMenu), findsOneWidget);
      await tester.pumpAndSettle();
      // Tap category image to go to go to ChildBoards
      await tester.tap(find.byKey(const ValueKey("categoryRow-0")));
      await tester.pumpAndSettle();

      // Verify that the ChildBoards page is displayed
      expect(find.byType(ChildBoards), findsOneWidget);

      // Tap back button to go to go to ChildMainMenu
      await tester.tap(find.byKey(const ValueKey("backButton")));
      await tester.pumpAndSettle();

      // Verify that the ChildMainMenu page is displayed
      expect(find.byType(ChildMainMenu), findsOneWidget);
    });
  });
}
