import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/pages/authenticate/forgot_password_PAGE.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  // group('ForgotPasswordPage', () {
  //   final mockFirebaseAuth = MockFirebaseAuth();
  //   const email = 'test@example.com';

    testWidgets('should display email text field and reset password button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );

      expect(find.byType(MyTextField), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
    });

  //   testWidgets('should show success dialog when reset password button is pressed with valid email', (tester) async {
  //     when(mockFirebaseAuth.sendPasswordResetEmail(email: email)).thenAnswer((_) async {});

  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: ForgotPasswordPage(),
  //       ),
  //     );

  //     await tester.enterText(find.byType(MyTextField), email);
  //     await tester.tap(find.text('Reset Password'));
  //     await tester.pumpAndSettle();

  //     expect(find.text('Sent Password Reset link to $email'), findsOneWidget);
  //   });
  // });
}