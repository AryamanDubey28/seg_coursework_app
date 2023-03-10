import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/admin_side_menu.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/pages/visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  testWidgets("Menu has all the buttons", (WidgetTester tester) async {
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
          home: AdminSideMenu(),
        )));

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
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AdminSideMenu(
              mock: true,
            ),
          )));
      await tester.tap(find.byKey(const ValueKey("choiceBoards")));
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });
  });

  testWidgets("Visual timetable button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AdminSideMenu(),
          )));
      await tester.tap(find.byKey(const ValueKey("visualTimetable")));
      await tester.pumpAndSettle();

      expect(find.byType(VisualTimeTable), findsOneWidget);
    });
  });

  testWidgets("Child mode button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AdminSideMenu(
              mock: true,
            ),
          )));
      final Finder childModeButton = find.byKey(Key("childMode"));
      await tester.tap(childModeButton);
      await tester.pumpAndSettle();
      expect(find.byType(CustomizableColumn), findsOneWidget);
    });
  });

  // !!!! Add tests for each button when implementing their pages !!!!!
}
