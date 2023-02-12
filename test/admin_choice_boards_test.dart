import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/admin_choice_boards.dart';

void main() {
  testWidgets("Category header has all components",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MaterialApp(home: AdminChoiceBoards()));

      expect(find.byKey(const ValueKey("addCategoryButton")), findsOneWidget);

      expect(find.byKey(const ValueKey("categoryHeader")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryTitle")), findsWidgets);
      expect(find.byKey(const ValueKey("editCategoryButton")), findsWidgets);
      expect(find.byKey(const ValueKey("deleteButton")), findsWidgets);
      expect(find.byKey(const ValueKey("addItemButton")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryDrag")), findsWidgets);
    });
  });

  testWidgets("Category item has all components", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MaterialApp(home: AdminChoiceBoards()));

      expect(find.byKey(const ValueKey("categoryItem")), findsWidgets);
      expect(find.byKey(const ValueKey("itemImage")), findsWidgets);
      expect(find.byKey(const ValueKey("itemTitle")), findsWidgets);
      expect(find.byKey(const ValueKey("editItemButton")), findsWidgets);
      expect(find.byKey(const ValueKey("deleteButton")), findsWidgets);
      expect(find.byKey(const ValueKey("itemDrag")), findsWidgets);
    });
  });
}
