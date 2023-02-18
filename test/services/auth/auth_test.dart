import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/pages/authenticate/Auth.dart';
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

  test("create account", () async {
    print("creating dummy account");
    expect(await auth.createAccount("test@test.com", "Password123"), "Success");
  });

  test("sign in", () async {
    print("signing in account");
    expect(await auth.signIn("test@test.com", "Password123"), "Success");
  });

  test("incorrect email", () async {
    print("signing in account should fail");
    expect(await auth.signIn("test.com", "Password123"), "Unsuccessful");
  });
}
