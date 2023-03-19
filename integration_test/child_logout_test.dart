import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/main.dart' as app;
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/services/auth.dart';

void main() {
  //IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigate from child mode to admin page tests', () {
    testWidgets('input correct PIN, verify routes to Admin Page',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(); //waits to see if application is ready

      final Finder emailField = find.byKey(Key('email_text_field'));
      final Finder passwordField = find.byKey(Key('password_text_field'));
      final Finder signInButton = find.byKey(Key('sign_in_button'));

      await tester.enterText(emailField, 'ary@test.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, "Password123");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5));

      final ScaffoldState state =
          tester.firstState(find.byKey(Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder childMenu = find.byKey(Key("childMode"));
      await tester.tap(childMenu);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder logoutButton = find.byKey(Key("logoutButton"));
      final Finder passwordTextField = find.byKey(Key("logoutTextField"));
      final Finder submitButton = find.byKey(Key("submitButton"));
      final Auth auth = Auth(
          auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
      final String currentPin = await auth.getCurrentUserPIN();
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      await tester.enterText(passwordTextField, currentPin);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });

    testWidgets(
        'input incorrect PIN, verify message pops up and stays on Child Page',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(); //waits to see if application is ready

      await Future.delayed(Duration(seconds: 2));

      final ScaffoldState state =
          tester.firstState(find.byKey(Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder childMenu = find.byKey(Key("childMode"));
      await tester.tap(childMenu);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      final Finder logoutButton = find.byKey(Key("logoutButton"));
      final Finder passwordTextField = find.byKey(Key("logoutTextField"));
      final Finder submitButton = find.byKey(Key("submitButton"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(passwordTextField, "1111");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.text("Incorrect PIN Provided"), findsOneWidget);
      await tester.tapAt(Offset(200, 200));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(CustomizableColumn), findsOneWidget);
    });
  });
}
