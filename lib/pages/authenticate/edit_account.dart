import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/edit_email_section.dart';
import 'package:seg_coursework_app/widgets/edit_password_section.dart';
import '../../widgets/my_text_field.dart';
import '../admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import '../admin/admin_side_menu.dart';
import '../../widgets/loading_indicator.dart';

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
  late final Auth authentitcationHelper;

  @override
  void initState() {
    super.initState();
    authentitcationHelper = Auth(auth: FirebaseAuth.instance);
  }

  // Displays an alert dialog with the text passed as parameter.
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
      backgroundColor: Colors.grey[200],
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
