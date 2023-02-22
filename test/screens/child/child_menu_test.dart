import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_row.dart';
import 'package:seg_coursework_app/widgets/category_image.dart';
import 'package:seg_coursework_app/widgets/category_row.dart';
import 'package:seg_coursework_app/widgets/category_title.dart';

// Test ensures that column of rows (categories) is displayed on screen
void main() {
  testWidgets('Test column (with rows) is present', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CustomizableColumn(),
    ));

    expect(find.byType(CustomizableColumn), findsWidgets);
    expect(find.byType(CustomizableRow), findsWidgets);
    expect(find.byType(CategoryImage), findsWidgets);
    expect(find.byType(CategoryTitle), findsWidgets);
    expect(find.byType(CategoryImageRow), findsWidgets);
  });
}
