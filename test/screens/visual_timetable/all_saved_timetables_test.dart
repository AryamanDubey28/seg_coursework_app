import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/admin/visual_timetable/all_saved_timetables.dart';
import 'package:seg_coursework_app/pages/admin/visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  testWidgets('All timetables shows nothing saved by default',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(),
          )));

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(find.byType(AllSavedTimetables), findsOneWidget);

      expect(find.byKey(const ValueKey("timetableRow0")), findsNothing);
    });
  });

  testWidgets('A timetable is saved when the add button is tapped.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(),
          )));

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("addToListOfListsButton")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("timetableRow0")), findsOneWidget);
    });
  });

  testWidgets('A timetable is deleted when the delete button is tapped.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(),
          )));

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("addToListOfListsButton")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("deleteButton0")), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("deleteButton0")));
      await tester.pump();

      expect(find.byKey(const ValueKey("deleteButton0")), findsNothing);

      expect(find.byKey(const ValueKey("timetableRow0")), findsNothing);
    });
  });
}
