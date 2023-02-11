import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/login.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    // TODO: implement authStateChanges
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  // final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  // final MainPage mp = MainPage();

  // setUp(() {});

  // tearDown(() {});

  // test("test123", () async {
  //   expectLater(mp.user, emitsInOrder([_mockUser]));
  // });

  // test("create user", () async {
  //   when(mockFirebaseAuth.createUserWithEmailAndPassword(
  //       email: "email", password: "password")).thenAnswer((realInvocation) => null);
  // });
}
