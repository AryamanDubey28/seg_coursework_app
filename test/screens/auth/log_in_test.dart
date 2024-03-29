import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/services/auth.dart';

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
    final _mockFirestore = FakeFirebaseFirestore();
    auth = Auth(auth: _mockAuth, firestore: _mockFirestore);
  });

  tearDown(() {});

  test('signIn function test', () async {
    final message = await auth.signIn(_email, _password);
    expect(message, "Success");
  });

  test("incorrect log in test", () async {
    final message = await auth.signIn("email", "password");
    expect(message, "Unsuccessful");
  });
}
