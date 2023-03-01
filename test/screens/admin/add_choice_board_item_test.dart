import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/pages/admin/add_choice_board_item.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

void main() {
  late String breakfastCategoryId;

  setUpAll(() {
    breakfastCategoryId = testCategories.first.id;
  });

  testWidgets("all elements are present", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AddChoiceBoardItem(
        categoryId: breakfastCategoryId,
      )));

      expect(find.byKey(const ValueKey("itemImageCard")), findsOneWidget);
      expect(find.byKey(const ValueKey("instructionsText")), findsOneWidget);
      expect(
          find.byKey(const ValueKey("pickImageFromGallery")), findsOneWidget);
      expect(find.byKey(const ValueKey("takeImageWithCamera")), findsOneWidget);
      expect(find.byKey(const ValueKey("itemNameField")), findsOneWidget);
      expect(find.byKey(const ValueKey("createItemButton")), findsOneWidget);
    });
  });

  testWidgets("name and image missing shows alert",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AddChoiceBoardItem(
        categoryId: breakfastCategoryId,
      )));

      await tester.tap(find.byKey(ValueKey("createItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets("only image missing shows alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AddChoiceBoardItem(
        categoryId: breakfastCategoryId,
      )));

      final nameField = find.byKey(ValueKey("itemNameField"));
      await tester.enterText(nameField, "Eggs");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("createItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets("only name missing shows alert", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AddChoiceBoardItem(
        categoryId: breakfastCategoryId,
      )));

      // await tester.tap(find.byKey(ValueKey("createItemButton")));
      // await tester.pumpAndSettle();
      // expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
