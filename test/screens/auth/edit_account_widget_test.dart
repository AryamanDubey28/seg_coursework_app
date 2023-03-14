import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

// Widget tests for all edit account functionality and error handling.
class MyMockUser extends MockUser {
  MyMockUser({super.email, super.uid, super.displayName});

  @override
  Future<void> updateEmail(String email) {
    if (email == "throw_known_error@tester.org") {
      throw FirebaseAuthException(code: "Simulation");
    } else if (email == "throw_unknown_error@tester.org") {
      throw Error();
    }
    return Future(() => null);
  }

  @override
  Future<void> updatePassword(String newPassword) {
    if (newPassword == "IAmWrong123") {
      throw Error();
    }
    return Future(() => null);
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential? credential) {
    if (credential!.asMap()['secret'] == "IAmWrong123") {
      throw FirebaseAuthException(code: "Simulation");
    }
    return super.reauthenticateWithCredential(credential);
  }
}

class MyMockFirebaseAuth extends MockFirebaseAuth {
  MyMockFirebaseAuth({super.mockUser}) {}
}

void main() {
  late FirebaseAuth mockAuth;
  late MockUser mockUser;
  late Auth auth;
  const _email = 'ilyas@yopmail.com';
  const _uid = 'sampleUid';
  const _displayName = 'ilyas';
  const _password = 'Test@123';
  final _mockUser = MyMockUser(
    uid: _uid,
    email: _email,
    displayName: _displayName,
  );

  setUpAll(() {
    mockAuth = MockFirebaseAuthentication();
    mockUser = MyMockUser(email: _email, uid: _uid, displayName: _displayName);
    when(mockAuth.currentUser).thenReturn(mockUser);
    final _mockAuth = MyMockFirebaseAuth(mockUser: _mockUser);
    auth = Auth(auth: _mockAuth);
  });

  testWidgets("Edit email correctly fails when given an unvalid email address.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder emailField = await find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          await find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, 'test.com');
      await tester.pumpAndSettle();

      await tester.tap(emailChangeButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "You did not input a valid email address so the change could not be made. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets("Edit email correctly fails when email field is empty.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder emailField = find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          await find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, '');
      await tester.pumpAndSettle();

      await tester.tap(emailChangeButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "You did not input a valid email address so the change could not be made. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets("Edit email is successful when given a valid email address",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder emailField = await find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          await find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, 'testing@frebase.com');
      await tester.pumpAndSettle();

      await tester.tap(emailChangeButton);
      await tester.pumpAndSettle();
      // Edit was successful.
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Your email was successfully changed.'), findsOneWidget);
    });
  });

  testWidgets(
      "Edit password gives correct error message if new password left empty",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, _password);
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, "");
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, 'Hello123!');
      await tester.pumpAndSettle();

      await tester.tap(passwordChangeButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "Some fields required to operate your password change were not filled in. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets(
      "Edit password gives correct error message if new password confirmation left empty",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, _password);
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, "Hello123!");
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, "");
      await tester.pumpAndSettle();

      await tester.tap(passwordChangeButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "Some fields required to operate your password change were not filled in. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets(
      "Edit password gives correct error message if current password left empty",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, "");
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, "Hello123!");
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, "Hello123!");
      await tester.pumpAndSettle();

      await tester.tap(passwordChangeButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "Some fields required to operate your password change were not filled in. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets(
      "Edit password gives correct error message if new password does not match the confirmation",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, _password);
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, "Hello123!");
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, "IDontMatch123");
      await tester.pumpAndSettle();

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              'The new password confirmation does not match the new password you demanded. Please try again.'),
          findsOneWidget);
    });
  });

  testWidgets(
      "Edit password gives correct error message if current password inputed is wrong",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, "IAmWrong123");
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, "Hello123!");
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, "Hello123!");
      await tester.pumpAndSettle();

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("Your current password is not correct. Please try again."),
          findsOneWidget);
    });
  });

  testWidgets(
      "Edit password gives correct error message if current password inputed is wrong",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder currentPasswordField =
          find.byKey(Key('current_password_input'));
      final Finder newPasswordField = find.byKey(Key('new_password_input'));
      final Finder confirmNewPasswordField =
          find.byKey(Key('confirm_new_password_input'));
      final Finder passwordChangeButton =
          find.byKey(Key('edit_password_submit'), skipOffstage: false);

      await tester.enterText(currentPasswordField, _password);
      await tester.pumpAndSettle();
      await tester.enterText(newPasswordField, "Hello123!");
      await tester.pumpAndSettle();
      await tester.enterText(confirmNewPasswordField, "Hello123!");
      await tester.pumpAndSettle();

      await tester.tap(passwordChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text("Your password was successfully changed."), findsOneWidget);
    });
  });

  testWidgets("Edit PIN works successfully when PIN is correct",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      // Wait for the element to be found
      await tester.runAsync(() async {
        while (tester.widget(find.byKey(ValueKey('pin_text_field'))) == null) {
          await Future.delayed(Duration(milliseconds: 50));
        }
      });

      // Scroll until the element is visible
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('pin_text_field')),
        200, // scroll by 200 pixels each time
      );

      // Find the element now that it is visible
      final pinTextField = find.byKey(ValueKey('pin_text_field'));
      final confirmPin = find.byKey(Key('make_pin_submit'));

      await tester.enterText(pinTextField, "0000");
      await tester.pumpAndSettle();
      await tester.tap(confirmPin, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Your PIN was successfully changed to 0000"),
          findsOneWidget);
    });
  });

  testWidgets("Edit PIN gives correct error if PIN is too short",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      // Wait for the element to be found
      await tester.runAsync(() async {
        while (tester.widget(find.byKey(ValueKey('pin_text_field'))) == null) {
          await Future.delayed(Duration(milliseconds: 50));
        }
      });

      // Scroll until the element is visible
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('pin_text_field')),
        200, // scroll by 200 pixels each time
      );

      // Find the element now that it is visible
      final pinTextField = find.byKey(ValueKey('pin_text_field'));
      final confirmPin = find.byKey(Key('make_pin_submit'));

      await tester.enterText(pinTextField, "0");
      await tester.pumpAndSettle();
      await tester.tap(confirmPin, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Please ensure your PIN is 4 digits"), findsOneWidget);
    });
  });

  testWidgets("Edit PIN gives correct error if PIN is too long",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      // Wait for the element to be found
      await tester.runAsync(() async {
        while (tester.widget(find.byKey(ValueKey('pin_text_field'))) == null) {
          await Future.delayed(Duration(milliseconds: 50));
        }
      });

      // Scroll until the element is visible
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('pin_text_field')),
        200, // scroll by 200 pixels each time
      );

      // Find the element now that it is visible
      final pinTextField = find.byKey(ValueKey('pin_text_field'));
      final confirmPin = find.byKey(Key('make_pin_submit'));

      await tester.enterText(pinTextField, "00000");
      await tester.pumpAndSettle();
      await tester.tap(confirmPin, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Please ensure your PIN is 4 digits"), findsOneWidget);
    });
  });

  testWidgets("Edit PIN gives correct error if PIN is not only made of digits",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
            isTestMode: true,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      // Wait for the element to be found
      await tester.runAsync(() async {
        while (tester.widget(find.byKey(ValueKey('pin_text_field'))) == null) {
          await Future.delayed(Duration(milliseconds: 50));
        }
      });

      // Scroll until the element is visible
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('pin_text_field')),
        200, // scroll by 200 pixels each time
      );

      // Find the element now that it is visible
      final pinTextField = find.byKey(ValueKey('pin_text_field'));
      final confirmPin = find.byKey(Key('make_pin_submit'));

      await tester.enterText(pinTextField, "0a0c");
      await tester.pumpAndSettle();
      await tester.tap(confirmPin, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Please ensure your PIN is 4 digits"), findsOneWidget);
    });
  });
}
