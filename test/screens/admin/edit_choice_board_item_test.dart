import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/pages/admin/edit_choice_board_item.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

void main() {
  late DraggableListItem toastItem;

  setUpAll(() {
    toastItem = testCategories.first.items.first;
  });

  testWidgets("all elements are present", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: EditChoiceBoardItem(
              itemId: toastItem.id,
              itemImageUrl: toastItem.imageUrl,
              itemName: toastItem.imageUrl)));

      expect(find.byKey(const ValueKey("itemImageCard")), findsOneWidget);
      expect(find.byKey(const ValueKey("instructionsText")), findsOneWidget);
      expect(
          find.byKey(const ValueKey("pickImageFromGallery")), findsOneWidget);
      expect(find.byKey(const ValueKey("takeImageWithCamera")), findsOneWidget);
      expect(find.byKey(const ValueKey("itemNameField")), findsOneWidget);
      expect(find.byKey(const ValueKey("editItemButton")), findsOneWidget);
    });
  });

  // DOES NOT WORK. SHOWS ALERT MESSAGE!!
  testWidgets("only name change", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: EditChoiceBoardItem(
              itemId: toastItem.id,
              itemImageUrl: toastItem.imageUrl,
              itemName: toastItem.imageUrl)));

      final nameField = find.byKey(ValueKey("itemNameField"));
      await tester.enterText(nameField, "Eggs");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("editItemButton")));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
