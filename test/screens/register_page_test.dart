import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/authenticate/register_page.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';

void main() {
  testWidgets("Register page has all components", (WidgetTester tester) async {
    
    await tester.pumpWidget(MaterialApp(home: RegisterPage(showLoginPage: () {})));

    expect(find.byKey(const ValueKey("account_circle_icon")), findsOneWidget);
    expect(find.text("Register Here!"), findsOneWidget);
    expect(find.byKey(const ValueKey("email_text_field")), findsOneWidget);
    expect(find.byKey(const ValueKey("pass_text_field")), findsOneWidget);
    expect(find.byKey(const ValueKey("pass_conf_text_field")), findsOneWidget);
    expect(find.byKey(const ValueKey("sign_up_button")), findsOneWidget);
    expect(find.text("Already have an account?"), findsOneWidget);
    expect(find.byKey(const ValueKey("go_back_button")), findsOneWidget);
  });


  
}
