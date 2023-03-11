import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future passwordReset() async {
    String text;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      text = "Sent Password Reset link to ${_emailController.text.trim()}";
    } on FirebaseAuthException catch (e) {
      text = e.message.toString();
    }
    ErrorDialogHelper(context: context).show_alert_dialog(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter your email to recieve a password reset link",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),

          //email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                ),
              ),
            ),
          ),

          //button
          MaterialButton(
            onPressed: passwordReset,
            color: Colors.deepPurple[300],
            child: Text(
              "Reset Password",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
