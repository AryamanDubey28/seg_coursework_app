import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authenticate/auth.dart';
import 'package:seg_coursework_app/pages/admin_interface.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Stream<User?> get user => FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if we are trying to sign in and snapshot contains user data, we are logged in
            return const AdminInterface();
          } else {
            //snapshot does not contain user data therefore, not logged in
            return const AuthPage();
          }
        },
      ),
    );
  }
}
