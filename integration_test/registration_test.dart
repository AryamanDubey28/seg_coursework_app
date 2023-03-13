import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seg_coursework_app/main.dart' as app;
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

Future<void> addDelay() async {
  await Future<void>.delayed(Duration(milliseconds: 1000));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("registration tests", () {
    testWidgets("Testing valid sign up", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final createAccountButton = find.byKey(Key('create_account'));
      await Future.delayed(Duration(seconds: 2));

      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailfortesting@gmail.com");
      await Future.delayed(Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, "Password123,");
      await Future.delayed(Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.enterText(passConfField, "Password123,");
      await Future.delayed(Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AdminChoiceBoards), findsOneWidget);

      final ScaffoldState state =
          tester.firstState(find.byKey(Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder logoutButton = find.byKey(Key("logout"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      // final auth = FirebaseAuth.instance;
      // auth.currentUser!.delete();
    });

    testWidgets("Testing invalid sign up", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final createAccountButton = find.byKey(Key('create_account'));
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailaddressfortesting@gmail.com");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(passConfField, "WrongPassword");
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AdminChoiceBoards), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("Password confirmation did not match. Please try again."),
          findsOneWidget);

      await Future.delayed(Duration(seconds: 2));
    });
  });
}
