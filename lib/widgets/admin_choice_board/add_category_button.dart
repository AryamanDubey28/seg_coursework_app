import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/add_choice_board_category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';

import '../dialogs/hero_dialog_route.dart';

/// The button in the Admin Choice Boards page to add
/// a new category
class AddCategoryButton extends StatefulWidget {
  final bool mock;
  const AddCategoryButton({super.key, this.mock = false});

  @override
  State<AddCategoryButton> createState() => _AddCategoryButtonState();
}

class _AddCategoryButtonState extends State<AddCategoryButton> {
  @override
  void dispose() {
    if (!widget.mock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      key: const Key("addCategoryButton"),
      onPressed: addCategory,
      icon: const Icon(Icons.add),
      label: const Text("Add a category"),
    );
  }

  /// open the add category popup (Add choice board category page)
  void addCategory() {
    if (!widget.mock && !CheckConnection.isDeviceConnected) {
      // User has no internet connection
      ErrorDialogHelper(context: context).show_alert_dialog(
          "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
      return;
    }
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return AddChoiceBoardCategory();
    }));
  }
}
