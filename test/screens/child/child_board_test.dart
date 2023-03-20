import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
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
      ClickableImage test_image = ClickableImage(
          name: "test",
          imageUrl:
              "data:image/jpeg;base64,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",
          is_available: true);
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: ChildBoards(
              categoryTitle: "",
              categoryImage: test_image,
              images: [],
            ),
          )));

      // Verify that the board menu is displayed
      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);

      // Verify that the category image is displayed
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);
      // Verify that the category image is displayed
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);

      // Verify that the images grid is displayed
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsOneWidget);
      // Verify that the images grid is displayed
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsOneWidget);

      // Verify that the back button is displayed
      // Verify that the back button is displayed
      expect(find.byKey(const ValueKey("backButton")), findsWidgets);

      // Verify that the category name is displayed
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
            ),
          )));

      // Verify that the CustomizableColumn page is displayed
      expect(find.byType(CustomizableColumn), findsOneWidget);
      await tester.pumpAndSettle();
      // Tap category image to go to go to ChildBoards
      await tester.tap(find.byKey(const ValueKey("row0")));
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
