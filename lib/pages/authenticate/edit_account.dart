import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/widgets/edit_account/edit_email_section.dart';
import 'package:seg_coursework_app/widgets/edit_account/edit_password_section.dart';
import 'package:seg_coursework_app/widgets/edit_account/edit_pin_section.dart';

import '../admin/admin_side_menu.dart';

// Creates a screen and related functionalities for the user to be able to edit their email and password informations.
// ignore: must_be_immutable
class EditAccountPage extends StatefulWidget {
  late FirebaseAuth auth;
  late bool isTestMode;
  late FirebaseFirestore firebaseFirestore;

  EditAccountPage(
      {super.key,
      FirebaseAuth? auth,
      bool? isTestMode,
      FirebaseFirestore? firestore}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.isTestMode = isTestMode ?? false;
    this.firebaseFirestore = firestore ?? FirebaseFirestore.instance;
  }

  @override
  State<EditAccountPage> createState() =>
      EditAccountPageState(auth, firebaseFirestore);
}

class EditAccountPageState extends State<EditAccountPage> {
  final _emailEditController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final Auth authentitcationHelper;
  late FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;

  EditAccountPageState(this.auth, this.firebaseFirestore);

  @override
  void initState() {
    super.initState();
    authentitcationHelper = Auth(auth: auth, firestore: firebaseFirestore);
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        key: const Key('app_bar'),
        title: const Text('Edit Account'),
      ),
      drawer: AdminSideMenu(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
                width: 1000,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EditEmailSection(
                        authentitcationHelper: authentitcationHelper,
                        isTestMode: widget.isTestMode),
                    EditPasswordSection(
                        authentitcationHelper: authentitcationHelper,
                        isTestMode: widget.isTestMode),
                    EditPINSection(
                        authentitcationHelper: authentitcationHelper,
                        isTestMode: widget.isTestMode)
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
