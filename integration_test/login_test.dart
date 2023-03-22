import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seg_coursework_app/main.dart' as app;
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';

void main() {
  group('sign in tests', () {
    testWidgets('input correct email and password, verify sign in',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(); //waits to see if application is ready

      await Future.delayed(const Duration(seconds: 2));

      final Finder emailField = find.byKey(const Key('email_text_field'));
      final Finder passwordField = find.byKey(const Key('password_text_field'));
      final Finder signInButton = find.byKey(const Key('sign_in_button'));

      await tester.enterText(emailField, 'ary@test.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123");
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));

      expect(find.byType(AdminChoiceBoards), findsOneWidget);

      final ScaffoldState state =
          tester.firstState(find.byKey(const Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      final Finder logoutButton = find.byKey(const Key("logout"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
    });
  });
}
