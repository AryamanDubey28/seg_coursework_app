import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/services/auth.dart';

// Unit tests for the methods of the Auth class linked to editing an account.
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

void main() async {
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

  setUp(() {
    final _mockAuth = MyMockFirebaseAuth(mockUser: _mockUser);
    auth = Auth(auth: _mockAuth);
  });

  tearDown(() {});

  test('update email works when provided with valid email', () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserEmail("newemail@tester.org"),
        'Your email was successfully changed.');
  });

  test(
      'update email throws proper message when there is no identifiable logged in user',
      () async {
    expect(await auth.editCurrentUserEmail("newemail@tester.org"),
        'We could not verify your identity. Please log out and back in.');
  });

  test(
      'update email throws proper message when there authentication can not be realized by Firebase',
      () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserEmail("throw_known_error@tester.org"),
        'We could not securely verify your identity. Please log out and back in to carry out this change.');
  });

  test(
      'update email throws proper message when there is an unknown database error',
      () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserEmail("throw_unknown_error@tester.org"),
        'We could not connect to the database. Please try again later.');
  });

  test(
      'update password works when provided with valid current password and password argument',
      () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserPassword(_password, "newPassword123"),
        "Your password was successfully changed.");
  });

  test(
      'update password returns proper error message when current password is incorrect',
      () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserPassword("FALSE", "newPassword123"),
        'Your current password is not correct. Please try again.');
  });

  test(
      'update password returns proper error message when an unknwon database error occurs',
      () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserPassword(_password, "throw_unknown_error"),
        'We are sorry, we could not change your password. Please try again.');
  });

  test(
      'update password returns proper error message if there is no identifiable logged in user',
      () async {
    expect(await auth.editCurrentUserPassword(_password, "newPassword123"),
        'We could not verify your identity. Please log out and back in.');
  });
}
