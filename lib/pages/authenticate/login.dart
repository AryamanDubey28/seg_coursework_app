import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/pages/authenticate/forgot_password_page.dart';
import 'package:seg_coursework_app/widgets/my_text_field.dart';

class LogIn extends StatefulWidget {
  final VoidCallback showRegisterPage;
  final FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;

  LogIn({
    Key? key,
    required this.showRegisterPage,
    required this.auth,
    FirebaseFirestore? firebaseFirestore,
  }) {
    this.firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  }

  @override
  State<LogIn> createState() => _LogInState(auth, firebaseFirestore);
}

class _LogInState extends State<LogIn> {
  //email and password controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final Auth authentitcationHelper;
  late FirebaseFirestore firebaseFirestore;
  late FirebaseAuth auth;
  late ErrorDialogHelper errorDialogHelper;

  _LogInState(this.auth, this.firebaseFirestore);

  @override
  void initState() {
    super.initState();

    authentitcationHelper = Auth(auth: auth, firestore: firebaseFirestore);
    errorDialogHelper = ErrorDialogHelper(context: context);
  }

  //sign users in using Firebase method
  Future signIn() async {
    final result = await authentitcationHelper.signIn(
        _emailController.text.trim(), _passwordController.text.trim());
    if (result != "Success") {
      errorDialogHelper.show_alert_dialog(
          'This user either does not exist or the password is incorrect. Try again or click Forgot Password or register again');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 1000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //top icon or logo
                  const Icon(
                    Icons.waving_hand_outlined, //temp hello icon
                    size: 90,
                    color: Colors.black,
                  ),

                  //Welcoming text
                  const Text(
                    "Hello There",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 72,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 45,
                  ),

                  // email textfield
                  MyTextField(
                      key: Key('email_text_field'),
                      hint: "Email",
                      controller: _emailController),

                  const SizedBox(
                    height: 15,
                  ),

                  //password textfield
                  MyTextField(
                    key: Key('password_text_field'),
                    hint: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),

                  //forgot password
                  SizedBox(
                    height: 15,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgotPasswordPage();
                            }));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  SizedBox(
                    height: 88,
                    width: 566,
                    child: ElevatedButton(
                      key: Key('sign_in_button'),
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
                      onPressed: signIn,
                      child: Text("Sign in"),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  //not a memeber button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      TextButton(
                        key: Key('create_account'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        onPressed: () {
                          widget.showRegisterPage();
                        },
                        child: Text("Register Now!"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
