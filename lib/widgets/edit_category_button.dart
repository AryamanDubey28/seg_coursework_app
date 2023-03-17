import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/edit_choice_board_category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/widgets/hero_dialog_route.dart';

/// Uses new category information to edit existing category
class EditCategoryButton extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImageUrl;
  final bool mock;

  const EditCategoryButton(
      {super.key,
      this.mock = false,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImageUrl});

  @override
  State<EditCategoryButton> createState() => _EditCategoryButtonState();
}

class _EditCategoryButtonState extends State<EditCategoryButton> {
  @override
  void dispose() {
    if (!widget.mock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key("editCategoryButton-${widget.categoryId}"),
      onPressed: editCategory,
      icon: Icon(Icons.edit, color: Color.fromARGB(255, 0, 76, 153)),
    );
  }

  /// open the edit category popup (Edit choice board category page)
  void editCategory() {
    if (!widget.mock && !CheckConnection.isDeviceConnected) {
      // User has no internet connection
      ErrorDialogHelper(context: context).show_alert_dialog(
          "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
      return;
    }
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return EditChoiceBoardCategory(
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
          categoryImageUrl: widget.categoryImageUrl);
    }));
  }
}
