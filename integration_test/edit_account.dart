import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

void main() {
  group("Email edit section", () {
    //   This test tests that the edit email portion of the page is properly connected to the editCurrentUserEmail
    // from the Auth class. The actual workings of this method are tested in unit tests and do not concern this test.
    testWidgets(
        'Edit email calls proper method from Auth class when given a valid email',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder emailField = find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, 'teest@gmail.com');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(emailChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("The email address is already in use by another account."),
          findsOneWidget);
    });

    testWidgets('Edit email gives error message when email is not valid',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder emailField = find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, 'test.com');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(emailChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "You did not input a valid email address so the change could not be made. Please try again."),
          findsOneWidget);
    });

    testWidgets('Edit email gives error message when email is not valid',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder emailField = find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, '');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(emailChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "You did not input a valid email address so the change could not be made. Please try again."),
          findsOneWidget);
    });
  });

  group("Password edit section", () {
    testWidgets(
        'Edit password is successful when given all fields and valid current password',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.binding.setSurfaceSize(const Size(1000, 1000));

      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, 'Hello123!');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("Your password was successfully changed."), findsOneWidget);
    });

    testWidgets(
        'Edit password gives proper error message when the current password is missing',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      expect(find.byKey(Key('edit_password_submit')), findsOneWidget);
      await tester.enterText(currentPasswordField, '');
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, 'Hello123!');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(
          find.text(
              "Some fields required to operate your password change were not filled in. Please try again."),
          findsOneWidget);
    });

    testWidgets(
        'Edit password gives proper error message when the new password is missing',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, '');
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, 'Hello123!');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(
          find.text(
              "Some fields required to operate your password change were not filled in. Please try again."),
          findsOneWidget);
    });

    testWidgets(
        'Edit password gives proper error message when the new password confirmation is missing',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, '');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(
          find.text(
              "Some fields required to operate your password change were not filled in. Please try again."),
          findsOneWidget);
    });

    testWidgets(
        'Edit password gives proper error message when the new password and its confirmation are different',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "anton@change.com", password: "Hello123!");
      runApp(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: EditAccountPage(),
          )));
      ;
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, 'Hello123!');
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, 'NotTheSame123');
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(
          find.text(
              "The new password confirmation does not match the new password you demanded. Please try again."),
          findsOneWidget);
    });
  });
}
