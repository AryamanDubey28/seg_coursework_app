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
          findsWidgets);
      expect(find.byKey(ValueKey("categoryImage-$breakfastCategoryId")),
          findsWidgets);
      expect(find.byKey(ValueKey("categoryTitle-$breakfastCategoryId")),
          findsWidgets);
      expect(find.byKey(ValueKey("editCategoryButton-$breakfastCategoryId")),
          findsWidgets);
      expect(find.byKey(ValueKey("deleteCategoryButton-$breakfastCategoryId")),
          findsWidgets);
      expect(find.byKey(ValueKey("addItemButton-$breakfastCategoryId")),
          findsWidgets);
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

      expect(find.byKey(ValueKey("categoryItem-$toastItemId")), findsWidgets);
      expect(find.byKey(ValueKey("itemImage-$toastItemId")), findsWidgets);
      expect(find.byKey(ValueKey("itemTitle-$toastItemId")), findsWidgets);
      expect(find.byKey(ValueKey("editItemButton-$toastItemId")), findsWidgets);
      expect(
          find.byKey(ValueKey("deleteItemButton-$toastItemId")), findsWidgets);
      expect(find.byKey(ValueKey("itemDrag")), findsWidgets);
    });
  });
}
