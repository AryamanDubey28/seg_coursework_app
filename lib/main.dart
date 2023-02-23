import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'pages/authenticate/wrapper.dart';
import 'themes/theme_provider.dart';

Future main() async {
  final themeNotifier = CustomTheme();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ThemeProvider(
    themeNotifier: themeNotifier,
    child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
