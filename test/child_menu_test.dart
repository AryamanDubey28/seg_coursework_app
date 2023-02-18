import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/child_menu.dart';

// Test ensures that column of rows (categories) is displayed on screen

void main() {
  testWidgets('Test containers', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CustomizableColumn(rowConfigs: [
        {
          'categoryTitle': 'Category 1',
          'images': [new Image.asset("test/assets/test_image.png")],
        },
        {
          'categoryTitle': 'Category 2',
          'images': [new Image.asset("test/assets/test_image.png")],
        },
        {
          'categoryTitle': 'Category 3',
          'images': [new Image.asset("test/assets/test_image.png")],
        },
        {
          'categoryTitle': 'Category 4',
          'images': [new Image.asset("test/assets/test_image.png")],
        },
      ]),
    ));

    expect(find.byType(CustomizableColumn), findsOneWidget);
  });
}
