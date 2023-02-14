import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/Auth.dart';
import 'package:seg_coursework_app/login.dart';
import 'package:seg_coursework_app/main_page.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>()])
import 'auth_test.mocks.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);

  setUp(() {});

  tearDown(() {});

  // test("emit occurs", () async {
  //   expectLater(auth.user, emitsInOrder([_mockUser]));
  // });

  // when(mockFirebaseAuth.createUserWithEmailAndPassword(
  //         email: "test@test.com", password: "Password123"))
  //     .thenReturn(expected);

  test("create account", () async {
    print("creating dummy account");
    expect(await auth.createAccount("test@test.com", "Password123"), "Success");
  });

  test("sign in", () async {
    print("signing in account");
    expect(await auth.signIn("test@test.com", "Password123"), "Success");
  });

  test("incorrect sign in", () async {
    print("signing in account should fail");
    expect(await auth.signIn("t@test.com", "Pass123"), "Unsuccessful");
  });
}
