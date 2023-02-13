import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seg_coursework_app/main.dart' as app;

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("registration tests", () {
    testWidgets("input correct email and password, verify connection",
        (tester) async {
      app.main();

      await tester.pumpAndSettle();

      await addDelay(2000);

      final createAccountButton = find.byKey(Key('create_account'));

      await tester.tap(createAccountButton);

      await tester.pumpAndSettle();
      await addDelay(2000);

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(
          emailField, "testemailaddressfortesting@gmail.com");
      await tester.enterText(passwordField, "Password123,");
      await tester.enterText(passConfField, "Password123,");
      await addDelay(2000);

      await tester.tap(signUpButton);

      await tester.pumpAndSettle();

      await addDelay(2000);
      
      expect(find.text("Signed in as: testemailaddressfortesting@gmail.com"),
          findsOneWidget);

      final auth = FirebaseAuth.instance;
      auth.currentUser!.delete();
      auth.signOut();
    });
  });
}
