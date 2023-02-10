import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test("Testing log in is correct", () async {
    //setup
    final user = MockUser(
      isAnonymous: false,
      uid: 'MlKC55kgegXCDgVLQNUYd4h9f893',
      email: 'aryaman@test.com',
      displayName: 'Aryaman',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    final result = await auth.signInWithEmailAndPassword(
        email: "aryaman@test.com", password: "Password123");
    final _user = await result.user;
    final userEmail = _user!.email;
    print("email = $userEmail which should be equal to aryaman@test.com");
    expect(userEmail, "aryaman@test.com");
  });

  test("Testing incorrect details do not log in", () async {
    final user = MockUser(
      isAnonymous: false,
      uid: '',
      email: '',
      displayName: 'Tester1',
    );
    String response = "";
    try {
      final auth = MockFirebaseAuth(mockUser: user);
      final result =
          await auth.signInWithEmailAndPassword(email: "", password: "");
      final _user = await result.user;
      final userEmail = _user!.email;
      //print("logged in as $userEmail");
    } on FirebaseAuthException {
      print("authentication exception occurred");
      response = "unsuccessful";
    }
  });
}
