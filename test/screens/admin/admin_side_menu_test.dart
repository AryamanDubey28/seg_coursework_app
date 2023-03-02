import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/admin_side_menu.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/pages/visual_timetable/visual_timetable.dart';

void main() {
  testWidgets("Menu has all the buttons", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminSideMenu(mock: true)));

    expect(find.byKey(const ValueKey("choiceBoards")), findsOneWidget);
    expect(find.byKey(const ValueKey("visualTimetable")), findsOneWidget);
    expect(find.byKey(const ValueKey("childMode")), findsOneWidget);
    expect(find.byKey(const ValueKey("appColours")), findsOneWidget);
    expect(find.byKey(const ValueKey("accountDetails")), findsOneWidget);
    expect(find.byKey(const ValueKey("logout")), findsOneWidget);
  });

  testWidgets("Choice boards button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MaterialApp(
          home: AdminSideMenu(
        mock: true,
      )));
      await tester.tap(find.byKey(const ValueKey("choiceBoards")));
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("Visual timetable button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester
          .pumpWidget(const MaterialApp(home: AdminSideMenu(mock: true)));
      await tester.tap(find.byKey(const ValueKey("visualTimetable")));
      await tester.pumpAndSettle();

      expect(find.byType(VisualTimeTable), findsOneWidget);
    });
  });

  testWidgets("Child mode button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester
          .pumpWidget(const MaterialApp(home: AdminSideMenu(mock: true)));
      await tester.tap(find.byKey(const ValueKey("childMode")));
      await tester.pumpAndSettle();

      expect(find.byType(CustomizableColumn), findsOneWidget);
    });
  });

  // !!!! Add tests for each button when implementing their pages !!!!!
}
