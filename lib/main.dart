import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/authenticate/wrapper.dart';
import 'pages/admin/edit_account.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditAccountPage(),
    );
  }
}
