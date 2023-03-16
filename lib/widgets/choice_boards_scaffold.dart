import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_side_menu.dart';

/// The scaffold of the Admin choice boards page
class ChoiceBoardsScaffold extends StatelessWidget {
  final String title;
  final Widget bodyWidget;
  final Widget? floatingButton;
  final FloatingActionButtonLocation? floatingButtonLocation;
  const ChoiceBoardsScaffold(
      {super.key,
      required this.title,
      required this.bodyWidget,
      this.floatingButton,
      this.floatingButtonLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key('app_bar'),
        title: Text(title),
      ),
      drawer: const AdminSideMenu(),
      floatingActionButton: floatingButton,
      floatingActionButtonLocation: floatingButtonLocation,
      body: bodyWidget,
    );
  }
}
