import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset email sent! Check your inbox.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email address and we will send you a reset link.',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 1000,
              child: MyTextField(
                  hint: "Email address", controller: _emailController),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: passwordReset,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
