import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';

import '../../widgets/my_text_field.dart';


// This is the screen where the user can request for their password to get changed via email after they forgot it 

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

  // Main password reset method that toggles database email message
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
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 1000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please enter your email to receive a password reset link",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
          
                SizedBox(
                  height: 65,
                ),

                // Email field
                MyTextField(
                  controller: _emailController,
                  hint: 'Email',
                ),
          
                SizedBox(
                          height: 35,
                ),
          
                // Button
                SizedBox(
                          height: 88,
                          width: 566,
                          child: ElevatedButton(
                            key: Key('reset_password_button'),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepPurple[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: passwordReset,
                            child: Text("Reset Password"),
                          ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
