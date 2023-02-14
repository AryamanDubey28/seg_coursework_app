import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/Auth.dart';
import 'package:seg_coursework_app/login.dart';

void main() async {
  late Auth auth;
  const _email = 'ilyas@yopmail.com';
  const _uid = 'sampleUid';
  const _displayName = 'ilyas';
  const _password = 'Test@123';
  final _mockUser = MockUser(
    uid: _uid,
    email: _email,
    displayName: _displayName,
  );

  setUp(() {
    final _mockAuth = MockFirebaseAuth(mockUser: _mockUser);
    auth = Auth(auth: _mockAuth);
  });

  tearDown(() {});

  test('signIn function test', () async {
    final message = await auth.signIn(_email, _password);
    print("message = $message");
    expect(message, "Success");
  });

  test("incorrect log in test", () async {
    final message = await auth.signIn("email", "password");
    print("message = $message");
    expect(message, "Unsuccessful");
  });

  // final user = MockUser(
  //   isAnonymous: false,
  //   uid: 'MlKC55kgegXCDgVLQNUYd4h9f893',
  //   email: 'aryaman@test.com',
  //   displayName: 'Aryaman',
  // );
  // final auth = MockFirebaseAuth(mockUser: user);

  // test("Testing log in is correct", () async {
  //   //setup
  //   final user = MockUser(
  //     isAnonymous: false,
  //     uid: 'MlKC55kgegXCDgVLQNUYd4h9f893',
  //     email: 'aryaman@test.com',
  //     displayName: 'Aryaman',
  //   );
  //   final auth = MockFirebaseAuth(mockUser: user);

  //   when(auth.signInWithEmailAndPassword(
  //       email: "aryaman@test.com", password: "Password123"));
  //   UserCredential flag = await auth.signInWithEmailAndPassword(
  //       email: "aryaman@test.com", password: "Password123");
  //   expect(flag.user!.email, "aryaman@test.com");
  // });

  // test("Testing incorrect log in", () async {
  //   //setup
  //   final user = MockUser(
  //     isAnonymous: false,
  //     uid: 'MlKC55kgegXCDgVLQNUYd4h9f893',
  //     email: 'ary@test.com',
  //     displayName: 'Aryaman',
  //   );

  //   final auth = MockFirebaseAuth(mockUser: user);
  //   when(auth.signInWithEmailAndPassword(
  //           email: "faillll@test.com", password: "Passssword123"))
  //       .thenReturn(false);
  //   UserCredential flag = await auth.signInWithEmailAndPassword(
  //       email: "fail@test.com", password: "Password123");
  //   print("flag = $flag  name = ${flag.user?.displayName}");
  //   expect(flag.user!.email, "fail");
  // });
}
