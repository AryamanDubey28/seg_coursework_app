import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seg_coursework_app/main.dart' as app;
import 'package:seg_coursework_app/pages/home_page.dart';

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

      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailaddressfortesting@gmail.com");
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();

      await tester.enterText(passConfField, "Password123,");
      await tester.pumpAndSettle();


      await tester.tap(signUpButton);
      await tester.pumpAndSettle();


      expect(find.byType(HomePage), findsOneWidget);

      final auth = FirebaseAuth.instance;
      auth.currentUser!.delete();

      final signOutButton = find.byKey(Key('sign_out_button'));

      await tester.tap(signOutButton);
      await tester.pumpAndSettle();
    });

    testWidgets("Testing invalid sign up", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await addDelay();

      final createAccountButton = find.byKey(Key('create_account'));

      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();

      await addDelay();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailaddressfortesting@gmail.com");
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();

      await tester.enterText(passConfField, "WrongPassword");
      await tester.pumpAndSettle();

      await addDelay();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      await addDelay();
      
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Password confirmation did not match. Please try again."), findsOneWidget);
    });
  });
}
