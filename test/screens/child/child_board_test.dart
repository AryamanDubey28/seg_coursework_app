import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

import '../admin/delete_choice_board_category_test.dart';
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
            home: CustomizableColumn(
              mock: true,
              auth: MockFirebaseAuth(),
              firebaseFirestore: MockFirebaseFirestore(),
              storage: MockFirebaseStorage(),
              testCategories: testCategories,
            ),
          )));

      await tester.pumpAndSettle();
      // Verify that the CustomizableColumn page is displayed
      expect(find.byType(CustomizableColumn), findsOneWidget);
      await tester.pumpAndSettle();
      // Tap category image to go to go to ChildBoards
      await tester.tap(find.byKey(const ValueKey("categoryRow-0")));
      await tester.pumpAndSettle();

      // Verify that the ChildBoards page is displayed
      expect(find.byType(ChildBoards), findsOneWidget);

      // Tap back button to go to go to CustomizableColumn
      await tester.tap(find.byKey(const ValueKey("backButton")));
      await tester.pumpAndSettle();

      // Verify that the CustomizableColumn page is displayed
      expect(find.byType(CustomizableColumn), findsOneWidget);
    });
  });
}
