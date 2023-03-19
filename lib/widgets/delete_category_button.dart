import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/pages/admin/delete_choice_board_category.dart';
import 'package:seg_coursework_app/services/check_connection.dart';

/// Button that opens delete category popup when pressed
class DeleteCategoryButton extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  final bool mock;

  const DeleteCategoryButton(
      {super.key,
      this.mock = false,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage});

  @override
  State<DeleteCategoryButton> createState() => _DeleteCategoryButtonState();
}

class _DeleteCategoryButtonState extends State<DeleteCategoryButton> {
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
      key: Key("deleteCategoryButton-${widget.categoryId}"),
      onPressed: () {
        if (!widget.mock && !CheckConnection.isDeviceConnected) {
          // User has no internet connection
          ErrorDialogHelper(context: context).show_alert_dialog(
              "Cannot change data without an internet connection! \nPlease make sure you are connected to the internet.");
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteChoiceBoardCategory(
                    categoryId: widget.categoryId,
                    categoryName: widget.categoryName,
                    categoryImage: widget.categoryImage);
              });
        }
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }
}
