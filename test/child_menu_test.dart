import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/child_menu.dart';

// Test ensures that column of rows (categories) is displayed on screen

void main() {
  testWidgets('Test containers', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CustomizableColumn(),
    ));

    expect(find.byType(CustomizableColumn), findsOneWidget);
  });
}
