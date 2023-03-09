import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';

class MyMockUser extends MockUser {
  MyMockUser({super.email, super.uid, super.displayName});

  Future<void> updateEmail(String email) {
    if (email == "throw_known_error@tester.org") {
      throw FirebaseAuthException(code: "Simulation");
    } else if (email == "throw_unknown_error@tester.org") {
      throw Error();
    }
    return Future(() => null);
  }

  Future<void> updatePassword(String newPassword) {
    if (newPassword == "throw_unknown_error") {
      throw Error();
    }
    return Future(() => null);
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential? credential) {
    if (credential!.asMap()['secret'] == "FALSE") {
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
    mockUser = MockUser(uid: "user1");
    when(mockAuth.currentUser).thenReturn(mockUser);
    final _mockAuth = MyMockFirebaseAuth(mockUser: _mockUser);
    auth = Auth(auth: _mockAuth);
  });

  testWidgets(
      "Edit email correctly failed when given an unvalid email address.",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
              home: EditAccountPage(
            auth: mockAuth,
          ))));
      await auth.signIn(_email, _password);
      await tester.pumpAndSettle();

      final Finder emailField = await find.byKey(Key('email_text_field'));
      final Finder emailChangeButton =
          await find.byKey(Key('edit_email_submit'), skipOffstage: false);

      await tester.enterText(emailField, 'test.com');
      await tester.pumpAndSettle();

      await tester.tap(emailChangeButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          find.text(
              "You did not input a valid email address so the change could not be made. Please try again."),
          findsOneWidget);
    });
  });
}


//   //   testWidgets('Edit email gives error message when email is not valid',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder emailField = find.byKey(Key('email_text_field'));
//   //     final Finder emailChangeButton =
//   //         find.byKey(Key('edit_email_submit'), skipOffstage: false);

//   //     await tester.enterText(emailField, 'test.com');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(emailChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(find.byType(AlertDialog), findsOneWidget);
//   //     expect(
//   //         find.text(
//   //             "You did not input a valid email address so the change could not be made. Please try again."),
//   //         findsOneWidget);
//   //   });

//   //   testWidgets('Edit email gives error message when email is not valid',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder emailField = find.byKey(Key('email_text_field'));
//   //     final Finder emailChangeButton =
//   //         find.byKey(Key('edit_email_submit'), skipOffstage: false);

//   //     await tester.enterText(emailField, '');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(emailChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(find.byType(AlertDialog), findsOneWidget);
//   //     expect(
//   //         find.text(
//   //             "You did not input a valid email address so the change could not be made. Please try again."),
//   //         findsOneWidget);
//   //   });
//   // });

//   // group("Password edit section", () {
//   //   testWidgets(
//   //       'Edit password is successful when given all fields and valid current password',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.binding.setSurfaceSize(const Size(1000, 1000));

//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder currentPasswordField =
//   //         find.byKey(Key('current_password_input'));
//   //     final Finder newPasswordField = find.byKey(Key('new_password_input'));
//   //     final Finder confirmNewPasswordField =
//   //         find.byKey(Key('confirm_new_password_input'));
//   //     final Finder passwordChangeButton =
//   //         find.byKey(Key('edit_password_submit'), skipOffstage: false);

//   //     await tester.enterText(currentPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(newPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(confirmNewPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(passwordChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(find.byType(AlertDialog), findsOneWidget);
//   //     expect(
//   //         find.text("Your password was successfully changed."), findsOneWidget);
//   //   });

//   //   testWidgets(
//   //       'Edit password gives proper error message when the current password is missing',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder currentPasswordField =
//   //         find.byKey(Key('current_password_input'));
//   //     final Finder newPasswordField = find.byKey(Key('new_password_input'));
//   //     final Finder confirmNewPasswordField =
//   //         find.byKey(Key('confirm_new_password_input'));
//   //     final Finder passwordChangeButton =
//   //         find.byKey(Key('edit_password_submit'), skipOffstage: false);

//   //     expect(find.byKey(Key('edit_password_submit')), findsOneWidget);
//   //     await tester.enterText(currentPasswordField, '');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(newPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(confirmNewPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(passwordChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(
//   //         find.text(
//   //             "Some fields required to operate your password change were not filled in. Please try again."),
//   //         findsOneWidget);
//   //   });

//   //   testWidgets(
//   //       'Edit password gives proper error message when the new password is missing',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder currentPasswordField =
//   //         find.byKey(Key('current_password_input'));
//   //     final Finder newPasswordField = find.byKey(Key('new_password_input'));
//   //     final Finder confirmNewPasswordField =
//   //         find.byKey(Key('confirm_new_password_input'));
//   //     final Finder passwordChangeButton =
//   //         find.byKey(Key('edit_password_submit'), skipOffstage: false);

//   //     await tester.enterText(currentPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(newPasswordField, '');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(confirmNewPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(passwordChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(
//   //         find.text(
//   //             "Some fields required to operate your password change were not filled in. Please try again."),
//   //         findsOneWidget);
//   //   });

//   //   testWidgets(
//   //       'Edit password gives proper error message when the new password confirmation is missing',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder currentPasswordField =
//   //         find.byKey(Key('current_password_input'));
//   //     final Finder newPasswordField = find.byKey(Key('new_password_input'));
//   //     final Finder confirmNewPasswordField =
//   //         find.byKey(Key('confirm_new_password_input'));
//   //     final Finder passwordChangeButton =
//   //         find.byKey(Key('edit_password_submit'), skipOffstage: false);

//   //     await tester.enterText(currentPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(newPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(confirmNewPasswordField, '');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(passwordChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(
//   //         find.text(
//   //             "Some fields required to operate your password change were not filled in. Please try again."),
//   //         findsOneWidget);
//   //   });

//   //   testWidgets(
//   //       'Edit password gives proper error message when the new password and its confirmation are different',
//   //       (tester) async {
//   //     WidgetsFlutterBinding.ensureInitialized();
//   //     await Firebase.initializeApp();
//   //     FirebaseAuth.instance.signInWithEmailAndPassword(
//   //         email: "anton@change.com", password: "Hello123!");
//   //     runApp(ThemeProvider(
//   //         themeNotifier: CustomTheme(),
//   //         child: MaterialApp(
//   //           home: EditAccountPage(),
//   //         )));
//   //     ;
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     final Finder currentPasswordField =
//   //         find.byKey(Key('current_password_input'));
//   //     final Finder newPasswordField = find.byKey(Key('new_password_input'));
//   //     final Finder confirmNewPasswordField =
//   //         find.byKey(Key('confirm_new_password_input'));
//   //     final Finder passwordChangeButton =
//   //         find.byKey(Key('edit_password_submit'), skipOffstage: false);

//   //     await tester.enterText(currentPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(newPasswordField, 'Hello123!');
//   //     await tester.pumpAndSettle();
//   //     await tester.enterText(confirmNewPasswordField, 'NotTheSame123');
//   //     await tester.pumpAndSettle();

//   //     await Future.delayed(Duration(seconds: 2));

//   //     await tester.tap(passwordChangeButton, warnIfMissed: false);
//   //     await tester.pumpAndSettle();
//   //     await Future.delayed(Duration(seconds: 2));

//   //     expect(
//   //         find.text(
//   //             "The new password confirmation does not match the new password you demanded. Please try again."),
//   //         findsOneWidget);
//   //   });
//   // });
// // }
