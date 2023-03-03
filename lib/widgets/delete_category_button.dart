import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/delete_choice_board_category.dart';

/// Button that opens delete category popup when pressed
class DeleteCategoryButton extends StatefulWidget {
  final String categoryId;

  const DeleteCategoryButton({super.key, required this.categoryId});

  @override
  State<DeleteCategoryButton> createState() => _DeleteCategoryButtonState();
}

class _DeleteCategoryButtonState extends State<DeleteCategoryButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key("deleteCategoryButton-${widget.categoryId}"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteChoiceBoardCategory(categoryId: widget.categoryId);
            });
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }
}
