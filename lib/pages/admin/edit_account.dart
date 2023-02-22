import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/my_text_field.dart';
import 'admin_choice_boards.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({
    super.key,
  });

  @override
  State<EditAccountPage> createState() => EditAccountPageState();
}

class EditAccountPageState extends State<EditAccountPage> {
  final _emailEditController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future commit_changes() async {
    if (_emailEditController.text.trim() != "") {
    } else if (_currentPasswordController.text.trim() != "") {}
    // if (passwordConfirmed()) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return Center(
    //             child: CircularProgressIndicator(
    //           color: Colors.deepPurple[400],
    //         ));
    //       });
    //   try {
    //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: _emailController.text.trim(),
    //       password: _passwordController.text.trim(),
    //     );
    //     Navigator.of(context).pop();
    //   } on FirebaseAuthException catch (e) {
    //     Navigator.of(context).pop();
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return AlertDialog(
    //             content: Text(e.message.toString()),
    //           );
    //         });
    //   }
    // } else {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //             content: Text(
    //                 'Password confirmation did not match. Please try again.'));
    //       });
    // }
  }

  @override
  void dispose() {
    _emailEditController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AdminChoiceBoards(),
            ));
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 1000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Edit your details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 72,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  MyTextField(
                    key: Key('change_email_field'),
                    hint: "Email",
                    controller: _emailEditController,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Change password",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    key: Key('current_password_input'),
                    hint: "Current password",
                    controller: _currentPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    key: Key('new_password_input'),
                    hint: "New password",
                    controller: _newPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    key: Key('confirm_new_password'),
                    hint: "Password confirmation",
                    controller: _confirmPasswordController,
                    isPassword: true,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 88,
                    width: 566,
                    child: ElevatedButton(
                      key: Key('confirm button'),
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
                      onPressed: commit_changes,
                      child: Text("Confirm Changes"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
