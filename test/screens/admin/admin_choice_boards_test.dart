import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

void main() {
  testWidgets("Category header has all components",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AdminChoiceBoards(
        draggableCategories: testCategories,
      )));

      final String breakfastCategoryId = testCategories.first.id;

      expect(find.byKey(const ValueKey("addCategoryButton")), findsOneWidget);

      expect(find.byKey(ValueKey("categoryHeader-$breakfastCategoryId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("categoryImage-$breakfastCategoryId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("categoryTitle-$breakfastCategoryId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("editCategoryButton-$breakfastCategoryId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("deleteCategoryButton-$breakfastCategoryId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("addItemButton-$breakfastCategoryId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("categoryDrag")), findsWidgets);
    });
  });

  testWidgets("Category item has all components", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AdminChoiceBoards(
        draggableCategories: testCategories,
      )));

      final String toastItemId = testCategories.first.items.first.id;

      expect(find.byKey(ValueKey("categoryItem-$toastItemId")), findsOneWidget);
      expect(find.byKey(ValueKey("itemImage-$toastItemId")), findsOneWidget);
      expect(find.byKey(ValueKey("itemTitle-$toastItemId")), findsOneWidget);
      expect(
          find.byKey(ValueKey("editItemButton-$toastItemId")), findsOneWidget);
      expect(find.byKey(ValueKey("deleteItemButton-$toastItemId")),
          findsOneWidget);
      expect(find.byKey(ValueKey("itemDrag")), findsWidgets);
    });
  });

  testWidgets("Add item button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AdminChoiceBoards(
        draggableCategories: testCategories,
      )));

      final String breakfastCategoryId = testCategories.first.id;

      await tester
          .tap(find.byKey(ValueKey("addItemButton-$breakfastCategoryId")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("addItemHero-$breakfastCategoryId")),
          findsOneWidget);
    });
  });

  testWidgets("Edit item button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AdminChoiceBoards(
        draggableCategories: testCategories,
      )));

      final String toastItemId = testCategories.first.items.first.id;

      await tester.tap(find.byKey(ValueKey("editItemButton-$toastItemId")));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey("editItemHero-$toastItemId")), findsOneWidget);
    });
  });

  testWidgets("Delete item button shows confirmation alert",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: AdminChoiceBoards(
        draggableCategories: testCategories,
      )));

      final String toastItemId = testCategories.first.items.first.id;

      await tester.tap(find.byKey(ValueKey("deleteItemButton-$toastItemId")));
      await tester.pumpAndSettle();

      expect(
          find.byKey(ValueKey("deleteItemAlert-$toastItemId")), findsOneWidget);
    });
  });
}
