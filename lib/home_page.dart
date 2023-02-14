import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

/* Temporary Signed In Page */

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //signed in text
          Center(
              child: Text(
            "Signed in as: ${user.email}",
            style: TextStyle(fontSize: 38),
          )),
          SizedBox(
            height: 15,
          ),
          //button to sign out
          MaterialButton(
            key: Key('sign_out_button'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.deepPurple[400],
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
