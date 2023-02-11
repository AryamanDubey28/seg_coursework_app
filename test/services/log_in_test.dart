import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/login.dart';

void main() async {
  final user = MockUser(
    isAnonymous: false,
    uid: 'MlKC55kgegXCDgVLQNUYd4h9f893',
    email: 'aryaman@test.com',
    displayName: 'Aryaman',
  );
  final auth = MockFirebaseAuth(mockUser: user);
  LogIn logIn = LogIn();

  test("Testing log in is correct", () async {
    //setup
    when(auth.signInWithEmailAndPassword(email: "email", password: "password"));
    UserCredential flag = await auth.signInWithEmailAndPassword(
        email: "email", password: "password");
    expect(flag.user!.email, "email");
  });
}
