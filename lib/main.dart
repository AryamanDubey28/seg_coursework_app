// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'pages/authenticate/wrapper.dart';
import 'themes/theme_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeNotifier = CustomTheme();
  await Firebase.initializeApp();
  CheckConnection.startMonitoring();
  runApp(ThemeProvider(
    themeNotifier: themeNotifier,
    child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    final themeData = themeNotifier.getTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Wrapper(),
    );
  }
}
