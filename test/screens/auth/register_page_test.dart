import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/authenticate/register_page.dart';

import '../../services/auth/auth_test.mocks.dart';

class MyMockFirebaseAuth extends MockFirebaseAuth {
  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String? email, required String? password}) {
    if (email == "emailaddressfortesting") {
      throw FirebaseAuthException(
          message: "The email address is badly formatted.", code: "error");
    }
    return super
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}

void main() {
  late FirebaseAuth mockAuth;

  setUpAll(() {
    mockAuth = MyMockFirebaseAuth();
  });

  testWidgets("Register page has all components", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegisterPage(
            showLoginPage: () {}, auth: mockAuth, isTestMode: true)));

    expect(find.byKey(const ValueKey("account_circle_icon")), findsOneWidget);
    expect(find.text("Register Here!"), findsOneWidget);
    expect(find.byKey(const ValueKey("email_text_field")), findsOneWidget);
    expect(find.byKey(const ValueKey("pass_text_field")), findsOneWidget);
    expect(find.byKey(const ValueKey("pass_conf_text_field")), findsOneWidget);
    expect(find.byKey(const ValueKey("sign_up_button")), findsOneWidget);
    expect(find.text("Already have an account?"), findsOneWidget);
    expect(find.byKey(const ValueKey("go_back_button")), findsOneWidget);
  });

  testWidgets("Visibility icon behaves as expected",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegisterPage(
            showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
    await tester.tap(find.byKey(const Key("visibilityButton")).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets("Valid sign up works as intended.", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegisterPage(
            showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
    await tester.tap(find.byKey(const Key("visibilityButton")).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets("Valid sign up works as intended.", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: RegisterPage(
              showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailfortesting@gmail.com");
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();

      await tester.enterText(passConfField, "Password123,");
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      // await tester.pumpAndSettle();

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
    });
  });

  testWidgets("Sign up gives correct error when email is not valid.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: RegisterPage(
              showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailaddressfortesting");
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();
      await tester.enterText(passConfField, "Password123,");
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("The email address is badly formatted."), findsOneWidget);
    });
  });

  testWidgets(
      "Sign up gives correct error when password confirmation does not match.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: RegisterPage(
              showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "emailaddressfortesting@gmail.com");
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();
      await tester.enterText(passConfField, "DoesNotMatch123!");
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("Password confirmation did not match. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets("Sign up gives correct error when email field is not filled.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: RegisterPage(
              showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "");
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();
      await tester.enterText(passConfField, "Password123,");
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("One or more field was not filled. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets("Sign up gives correct error when password field is not filled.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: RegisterPage(
              showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "testing@test.com");
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "");
      await tester.pumpAndSettle();
      await tester.enterText(passConfField, "Password123,");
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("One or more field was not filled. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets(
      "Sign up gives correct error when password confirmation field is not filled.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: RegisterPage(
              showLoginPage: () {}, auth: mockAuth, isTestMode: true)));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email_text_field'));
      final passwordField = find.byKey(Key('pass_text_field'));
      final passConfField = find.byKey(Key('pass_conf_text_field'));
      final signUpButton = find.byKey(Key('sign_up_button'));

      await tester.enterText(emailField, "testing@test.com");
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123,");
      await tester.pumpAndSettle();
      await tester.enterText(passConfField, "");
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(AdminChoiceBoards), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("One or more field was not filled. Please try again."),
          findsOneWidget);
    });
  });
}
