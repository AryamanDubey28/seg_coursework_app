import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:seg_coursework_app/forgot_password_page.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  //email and password controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //sign users in using Firebase method
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'This user either does not exist or the password is incorrect. Try again or click Forgot Password or register again',
                style: TextStyle(fontSize: 24),
              ),
            );
          });
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //top icon or logo
                const Icon(
                  Icons.waving_hand_outlined, //temp hello icon
                  size: 90,
                ),

                //Welcoming text
                const Text(
                  "Hello There",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 72),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 44),
                ),
                const SizedBox(
                  height: 45,
                ),
                // email textfield
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                //password textfield

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
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                        ),
                      ),
                    ),
                  ),
                ),

                //forgot password
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ForgotPasswordPage();
                    }));
                  },
                  child: Text("Forgot Password?",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),

                SizedBox(
                  height: 15,
                ),

                //sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 400),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                //not a memeber button
                Text(
                  "Not a member?",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  "Register Now!",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
