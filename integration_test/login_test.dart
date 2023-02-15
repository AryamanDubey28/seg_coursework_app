import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seg_coursework_app/pages/admin/admin_interface.dart';
import 'package:seg_coursework_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('sign in tests', () {
    testWidgets('input correct email and password, verify sign in',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(); //waits to see if application is ready

      await Future.delayed(Duration(seconds: 2));

      final Finder email_field = find.byKey(Key('email_text_field'));
      final Finder password_field = find.byKey(Key('password_text_field'));
      final Finder sign_in_button = find.byKey(Key('sign_in_button'));

      await tester.enterText(email_field, 'test@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(password_field, "Password123");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      await tester.tap(sign_in_button);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AdminInterface), findsOneWidget);
    });

    // testWidgets(
    //     "input incorrect email and password verify error message pops up",
    //     (tester) async {
    //   app.main();

    //   await tester.pumpAndSettle(); //waits to see if application is ready

    //   await Future.delayed(Duration(seconds: 4));

      // final Finder email_field = find.byKey(Key('email_text_field'));
      // final Finder password_field = find.byKey(Key('password_text_field'));
      // final Finder sign_in_button = find.byKey(Key('sign_in_button'));

      // await tester.enterText(email_field, 't@gmail.com'); //wrong email
      // await tester.pumpAndSettle();
      // await tester.enterText(password_field, "Pword123"); //wrong password
      // await tester.pumpAndSettle();
      // await Future.delayed(Duration(seconds: 2));

      // await tester.tap(sign_in_button);
      // await tester.pumpAndSettle();
      // await Future.delayed(Duration(seconds: 2));

      // expect(
      //     find.text(
      //         'This user either does not exist or the password is incorrect. Try again or click Forgot Password or register again'),
      //     findsOneWidget);
    // });
  });
}
