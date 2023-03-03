import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/authenticate/wrapper.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();
  final isInChildMode = pref.getBool('isInChildMode') ??
      false; //will return true if in child mode, else false
  runApp(MyApp(isInChildMode: isInChildMode));
}

class MyApp extends StatelessWidget {
  final bool isInChildMode;
  const MyApp({Key? key, required this.isInChildMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      //home: Wrapper(),
      //home: isInChildMode ? ChildBoards() : Wrapper(),
      home: Wrapper(isInChildMode: isInChildMode),
    );
  }
}
