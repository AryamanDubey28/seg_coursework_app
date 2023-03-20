import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/admin_side_menu.dart';
import 'package:seg_coursework_app/pages/child/child_menu.dart';
import 'package:seg_coursework_app/pages/admin/theme_page/theme_page.dart';
import 'package:seg_coursework_app/pages/admin/visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';
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
    expect(find.byKey(const ValueKey("editAccount")), findsOneWidget);
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

      expect(find.byType(AdminChoiceBoard), findsOneWidget);
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
      expect(find.byType(ChildMenu), findsOneWidget);
    });
  });

  testWidgets("App colours button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AdminSideMenu(),
          )));
      await tester.tap(find.byKey(const ValueKey("appColours")));
      await tester.pumpAndSettle();

      expect(find.byType(ThemePage), findsOneWidget);
    });
  });

  testWidgets("Edit account button does correct page navigation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: AdminSideMenu(
              mock: true,
            ),
          )));
      await tester.tap(find.byKey(const ValueKey("editAccount")));
      await tester.pumpAndSettle();

      expect(find.byType(EditAccountPage), findsOneWidget);
    });
  });
}
