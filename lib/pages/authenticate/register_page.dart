import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import '../../widgets/general/my_text_field.dart';

/// Page for users to create a new account
class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  late final bool isTestMode;
  late final FirebaseAuth auth;

  RegisterPage(
      {super.key,
      required this.showLoginPage,
      FirebaseAuth? auth,
      bool? isTestMode}) {
    this.isTestMode = isTestMode ?? false;
    this.auth = auth ?? FirebaseAuth.instance;
  }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  /// Create a new account for the user
  Future signUp() async {
    if (_passwordController.text.trim() != "" &&
        _passwordConfirmationController.text.trim() != "" &&
        _emailController.text.trim() != "") {
      if (passwordConfirmed()) {
        if (!widget.isTestMode) {
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.deepPurple[400],
                ));
              });
        }
        try {
          await widget.auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          Navigator.of(context).pop();
        } on FirebaseAuthException catch (e) {
          Navigator.of(context).pop();
          ErrorDialogHelper(context: context)
              .showAlertDialog(e.message.toString());
        }
      } else {
        ErrorDialogHelper(context: context).showAlertDialog(
            'Password confirmation did not match. Please try again.');
      }
    } else {
      ErrorDialogHelper(context: context).showAlertDialog(
          'One or more field was not filled. Please try again.');
    }
  }

  bool passwordConfirmed() {
    return (_passwordController.text.trim() ==
        _passwordConfirmationController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordConfirmationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            widget.showLoginPage();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 1000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    key: Key("account_circle_icon"),
                    Icons.account_circle_sharp,
                    size: 90,
                    color: Colors.black,
                  ),
                  const Text(
                    "Register Here!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 72,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyTextField(
                    key: const Key('email_text_field'),
                    hint: "Email",
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    key: const Key('pass_text_field'),
                    hint: "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    key: const Key('pass_conf_text_field'),
                    hint: "Password Confirmation",
                    controller: _passwordConfirmationController,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 88,
                    width: 566,
                    child: ElevatedButton(
                      key: const Key('sign_up_button'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: signUp,
                      child: const Text("Sign up"),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.showLoginPage();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        child: const Text(
                          "Go Back",
                          key: Key("go_back_button"),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
