import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/main.dart' as app;
import 'package:seg_coursework_app/pages/child/child_main_menu.dart';

void main() {
  group("Test for child menu navigation", () {
    testWidgets('New Account with no PIN cannot navigate to child mode',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder emailField = find.byKey(const Key('email_text_field'));
      final Finder passwordField = find.byKey(const Key('password_text_field'));
      final Finder signInButton = find.byKey(const Key('sign_in_button'));

      await tester.enterText(emailField, 'noPINAccount@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123");
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));

      final ScaffoldState state =
          tester.firstState(find.byKey(const Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      final Finder childModeButton = find.byKey(const Key('childMode'));
      await tester.tap(childModeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));
      await tester.tapAt(const Offset(200, 200));
      expect(find.byType(ChildMainMenu), findsNothing);

      await Future.delayed(const Duration(seconds: 3));
      await tester.tapAt(const Offset(200, 200));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      final Finder logoutButton = find.byKey(const Key("logout"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
    });
  });
}
