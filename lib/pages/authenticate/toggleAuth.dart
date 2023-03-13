import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:seg_coursework_app/pages/authenticate/login.dart';
import 'package:seg_coursework_app/pages/authenticate/register_page.dart';

class ToggleAuth extends StatefulWidget {
  final FirebaseAuth auth;

  const ToggleAuth({required this.auth, super.key});

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
      return LogIn(showRegisterPage: toggleScreens, auth: widget.auth);
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
