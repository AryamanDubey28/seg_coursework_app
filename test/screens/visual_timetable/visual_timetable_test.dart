import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/picture_grid.dart';

void main() {
  testWidgets('PictureGrid is shown by default', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      // Verify that our PictureGrid is shown by default
      expect(find.byType(PictureGrid), findsOneWidget);
    });
  });

  testWidgets('Button to show all timetables is shown.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      expect(find.byKey(const ValueKey("allTimetablesButton")), findsOneWidget);
    });
  });

  testWidgets(
      'PictureGrid is hidden then reshown with the FloatingActionButton',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(PictureGrid), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(PictureGrid), findsOneWidget);
    });
  });

  testWidgets('Timetable images can be tapped to be removed from the timetable',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage2")));
      await tester.pump();

      expect(find.byKey(const ValueKey("timetableImage0")), findsOneWidget);
      expect(find.byKey(const ValueKey("timetableImage1")), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("timetableImage1")));
      await tester.pump();

      expect(find.byKey(const ValueKey("timetableImage0")), findsOneWidget);
      expect(find.byKey(const ValueKey("timetableImage1")), findsNothing);
    });
  });

  testWidgets(
      'PictureGrid is hidden when 5 images are chosen and shown when less are chosen',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      expect(find.byType(PictureGrid), findsNothing);

      await tester.tap(find.byKey(const ValueKey("timetableImage1")));
      await tester.pump();

      expect(find.byType(PictureGrid), findsOneWidget);
    });
  });

  testWidgets(
      'Add to list of lists button is shown when 2 or more images are added to the timetable.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsOneWidget);
    });
  });

  testWidgets(
      'Add to list of lists button is shown when 2 or more images are added to the timetable.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(themeNotifier: CustomTheme(), child: MaterialApp(home: VisualTimeTable(),)));

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("gridImage1")));
      await tester.pump();

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsOneWidget);
    });
  });
}
