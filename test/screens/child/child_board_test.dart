import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  testWidgets("Category has all components", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: ChildBoards(),)));

    // Verify that the category image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify that the images grid is displayed
    expect(find.byKey(const ValueKey("categoryTitle")), findsOneWidget);

    // Verify that the back button is displayed
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Verify that the category name is displayed
    expect(find.byKey(const ValueKey("mainGridOfPictures")), findsOneWidget);
  });

  testWidgets(
      'ChildBoards navigates back to the parent menu when the back button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChildBoards()));

    // Verify that the ChildBoards page is displayed
    expect(find.byType(ChildBoards), findsOneWidget);

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });
}
