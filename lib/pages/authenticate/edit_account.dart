import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/edit_email_section.dart';
import 'package:seg_coursework_app/widgets/edit_password_section.dart';
import 'package:seg_coursework_app/services/auth.dart';
import '../admin/admin_side_menu.dart';

// Creates a screen and related functionalities for the user to be able to edit their email and password informations.
class EditAccountPage extends StatefulWidget {
  late FirebaseAuth auth;

  EditAccountPage({super.key, FirebaseAuth? auth}) {
    this.auth = auth ?? FirebaseAuth.instance;
  }

  @override
  State<EditAccountPage> createState() => EditAccountPageState(auth);
}

class EditAccountPageState extends State<EditAccountPage> {
  final _emailEditController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final Auth authentitcationHelper;
  late FirebaseAuth auth;

  EditAccountPageState(this.auth);

  @override
  void initState() {
    super.initState();
    authentitcationHelper = Auth(auth: auth);
  }

  // Displays an alert dialog with the text passed as parameter.
  // ignore: non_constant_identifier_names
  void show_alert_dialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              text,
              style: TextStyle(fontSize: 24),
            ),
          );
        });
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        key: Key('app_bar'),
        title: const Text('Edit Account'),
      ),
      drawer: const AdminSideMenu(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
                width: 1000,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EditEmailSection(
                        authentitcationHelper: authentitcationHelper),
                    EditPasswordSection(
                        authentitcationHelper: authentitcationHelper),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
