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

      // final createAccountButton = find.byKey(Key('create_account'));
      // await Future.delayed(Duration(seconds: 2));

      // await tester.tap(createAccountButton);
      // await tester.pumpAndSettle();
      // await Future.delayed(Duration(seconds: 2));

      // final emailField = find.byKey(Key('email_text_field'));
      // final passwordField = find.byKey(Key('pass_text_field'));
      // final passConfField = find.byKey(Key('pass_conf_text_field'));
      // final signUpButton = find.byKey(Key('sign_up_button'));

      // await tester.enterText(emailField, "noPINAccount@gmail.com");
      // await Future.delayed(Duration(seconds: 2));
      // await tester.pumpAndSettle();

      // await tester.enterText(passwordField, "Password123");
      // await Future.delayed(Duration(seconds: 2));
      // await tester.pumpAndSettle();

      // await tester.enterText(passConfField, "Password123");
      // await Future.delayed(Duration(seconds: 2));
      // await tester.pumpAndSettle();

      // await tester.tap(signUpButton);
      // await tester.pumpAndSettle();
      // await Future.delayed(Duration(seconds: 2));

      final Finder emailField = find.byKey(Key('email_text_field'));
      final Finder passwordField = find.byKey(Key('password_text_field'));
      final Finder signInButton = find.byKey(Key('sign_in_button'));

      await tester.enterText(emailField, 'noPINAccount@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5));

      final ScaffoldState state =
          tester.firstState(find.byKey(Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder childModeButton = find.byKey(Key('childMode'));
      await tester.tap(childModeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5));
      await tester.tapAt(Offset(200, 200));
      expect(find.byType(ChildMainMenu), findsNothing);

      await Future.delayed(Duration(seconds: 3));
      await tester.tapAt(Offset(200, 200));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder logoutButton = find.byKey(Key("logout"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
    });
  });
}
