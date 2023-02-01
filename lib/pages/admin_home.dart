import 'package:flutter/material.dart';

// This widget is the root of the admin interface
class AdminInterface extends StatelessWidget {
  const AdminInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Home',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AdminHome(),
    );
  }
}

// The home page of the admin interface
class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
      );
}
