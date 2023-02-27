import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';

void main() {
  testWidgets("Edit account page has all components",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      Firebase.initializeApp();
      await tester.pumpWidget(const MaterialApp(home: EditAccountPage()));

      expect(find.byKey(const ValueKey("edit_email_submit")), findsWidgets);
      expect(find.byKey(const ValueKey("edit_email_prompt")), findsWidgets);
      // expect(find.byKey(const ValueKey("edit_email_field")), findsWidgets);

      // expect(find.byKey(const ValueKey("edit_password_submit")), findsWidgets);
      // expect(find.byKey(const ValueKey("confirm_new_password_input")),
      //     findsWidgets);
      // expect(find.byKey(const ValueKey("new_password_input")), findsWidgets);
      // expect(
      //     find.byKey(const ValueKey("current_password_input")), findsWidgets);
      // expect(find.byKey(const ValueKey("edit_password_prompt")), findsWidgets);
    });
  });
}
