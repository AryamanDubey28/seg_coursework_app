import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/authenticate/Auth.dart';

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
}
