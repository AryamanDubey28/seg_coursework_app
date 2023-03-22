import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>()])
import 'auth_test.mocks.dart';

class MockUser extends Mock implements User {}

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockFirestore = FakeFirebaseFirestore();
  final Auth auth = Auth(auth: mockFirebaseAuth, firestore: mockFirestore);

  setUp(() {});

  tearDown(() {});

  test("create account", () async {
    expect(await auth.signUp("test@test.com", "Password123"), "Success");
  });

  test("sign in", () async {
    expect(await auth.signIn("test@test.com", "Password123"), "Success");
  });

  test("incorrect email", () async {
    expect(await auth.signIn("test.com", "Password123"), "Unsuccessful");
  });
}
