import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/theme_page/theme_page.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/theme/theme_grid.dart';

void main() {
  testWidgets('ThemeGrid is shown', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ThemeProvider(
          themeNotifier: CustomTheme(),
          child: const MaterialApp(
            home: ThemePage(),
          ),
        ),
      );

      // Verify that our ThemeGrid is shown.
      expect(find.byType(ThemeGrid), findsOneWidget);
    });
  });

  testWidgets('Button to add theme is shown.', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ThemeProvider(
          themeNotifier: CustomTheme(),
          child: const MaterialApp(
            home: ThemePage(),
          ),
        ),
      );

      expect(find.byKey(const ValueKey("addThemeButton")), findsOneWidget);
    });
  });

  testWidgets('ThemeGrid themes can be tapped to be applied.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ThemeProvider(
          themeNotifier: CustomTheme(),
          child: const MaterialApp(
            home: ThemePage(),
          ),
        ),
      );

      final initialTheme = CustomTheme().getTheme();

      await tester.tap(find.byKey(const ValueKey("themeSquare3")));
      await tester.pumpAndSettle();

      final newTheme = CustomTheme().getTheme();

      // Verify that the theme has changed
      expect(
        newTheme,
        isNot(equals(initialTheme)),
      );
    });
  });
}
