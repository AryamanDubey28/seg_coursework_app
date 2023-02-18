import 'package:flutter/src/widgets/framework.dart';
import 'package:seg_coursework_app/pages/authenticate/login.dart';
import 'package:seg_coursework_app/pages/authenticate/register_page.dart';

class ToggleAuth extends StatefulWidget {
  const ToggleAuth({super.key});

  @override
  State<ToggleAuth> createState() => _ToggleAuthState();
}

class _ToggleAuthState extends State<ToggleAuth> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogIn(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
