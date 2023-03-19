import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/child/category_focus.dart';
import 'package:seg_coursework_app/pages/child/child_menu.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  testWidgets("Category has all components", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: CategoryFocus(),
          )));

      // Verify that the board menu is displayed
      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);

      // Verify that the category image is displayed
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);

      // Verify that the images grid is displayed
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsOneWidget);

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
            home: ChildMenu(
              mock: true,
            ), //mock PIN
          )));

      // Verify that the CustomizableColumn page is displayed
      expect(find.byType(ChildMenu), findsOneWidget);

      // Tap category image to go to go to ChildBoards
      await tester.tap(find.byKey(const ValueKey("row0")));
      await tester.pumpAndSettle();

      // Verify that the ChildBoards page is displayed
      expect(find.byType(CategoryFocus), findsOneWidget);

      // Tap back button to go to go to CustomizableColumn
      await tester.tap(find.byKey(const ValueKey("backButton")));
      await tester.pumpAndSettle();

      // Verify that the CustomizableColumn page is displayed
      expect(find.byType(ChildMenu), findsOneWidget);
    });
  });
}
