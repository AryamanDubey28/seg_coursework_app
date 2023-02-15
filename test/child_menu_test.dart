import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/child_menu/child_menu_widget.dart';

void main() {
  testWidgets('Test containers', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChildMenuWidget()));

    var testNumberOfWidgets = 1;
    expect(find.byType(ListView), findsNWidgets(testNumberOfWidgets));
  });
}
