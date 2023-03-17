// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'pages/authenticate/wrapper.dart';
import 'themes/theme_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeNotifier = CustomTheme();
  await Firebase.initializeApp();
  CheckConnection
      .startMonitoring(); // listener for user's internet connection status

  final pref = await SharedPreferences.getInstance();
  final auth = Auth(auth: FirebaseAuth.instance);
  final isInChildMode = pref.getBool('isInChildMode') ??
      false; //will return true if in child mode, else false
  runApp(ThemeProvider(
    themeNotifier: themeNotifier,
    child: MyApp(
      isInChildMode: isInChildMode,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final bool isInChildMode;
  const MyApp({Key? key, required this.isInChildMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    final themeData = themeNotifier.getTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Wrapper(
        isInChildMode: isInChildMode,
      ),
    );
  }
}
