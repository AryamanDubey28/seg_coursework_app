import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/services/admin.dart';
import 'package:seg_coursework_app/services/auth.dart';

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

  Future<String> getCurrentUserPIN() async {
    print(
        "--------------------------> In current user pin method in mock_user");
    return "0000";
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

class MyMockFirebaseFirestore extends FakeFirebaseFirestore {
  String userId;
  MyMockFirebaseFirestore({required this.userId}) {}

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    var map = {"userId": userId, "pin": "0000"};
    CollectionReference collectionReference = super.collection(path);
    print("in inherited method! uid = $userId");
    collectionReference.add(map);
    return collectionReference as CollectionReference<Map<String, dynamic>>;
  }
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
    final _mockFirestore = MyMockFirebaseFirestore(userId: "sampleUid");
    _mockFirestore.saveDocument("userPins");
    auth = Auth(auth: _mockAuth, mock: true, firestore: _mockFirestore);
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

  test("Get current user's id returns an id", () async {
    await auth.signIn(_email, _password);
    String? uid = await auth.getCurrentUserId(); //mocking returns sampleUid
    expect(uid, "sampleUid");
  });

  test("Admin page getCurrentUserId test", () async {
    await auth.signIn(_email, _password);
    Admin admin = Admin(user: _mockUser);
    String? uid =
        await admin.getCurrentUserId(); //_mockUser's id returns sampleUid
    expect(uid, "sampleUid");
  });

  test("Cannot set a PIN longer than 4 digits", () async {
    await auth.signIn(_email, _password);
    expect(await auth.createPIN("12345"),
        "Please ensure that your PIN is 4 digits");
  });

  test("Cannot create a PIN with characters and letters", () async {
    await auth.signIn(_email, _password);
    expect(await auth.createPIN("abcd"),
        "Please ensure that your PIN is 4 digits");
  });

  test("Entering valid PIN works", () async {
    await auth.signIn(_email, _password);
    expect(await auth.createPIN("1234"), "Successfully made your pin: 1234");
  });

  test("PIN exists for users", () async {
    await auth.signIn(_email, _password);
    bool result = await auth.checkPINExists();
    expect(result, true);
  });

  test("Cannot edit a PIN to be less than 4 digits", () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserPIN("123"),
        "Please ensure your new PIN is 4 digits");
  });

  test("Entering valid PIN sucessfully updates it", () async {
    await auth.signIn(_email, _password);
    expect(await auth.editCurrentUserPIN("9999"),
        "Your PIN was successfully changed to 9999");
  });

  test("Get Current User's PIN returns a PIN", () async {
    await auth.signIn(_email, _password);
    String pin = await auth.getCurrentUserPIN();
    expect(pin, "0000");
  });
}
