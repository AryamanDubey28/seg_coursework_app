import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/delete_choice_board_category.dart';

/// Button that opens delete category popup when pressed
class DeleteCategoryButton extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  const DeleteCategoryButton(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage});

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
              return DeleteChoiceBoardCategory(
                  categoryId: widget.categoryId,
                  categoryName: widget.categoryName,
                  categoryImage: widget.categoryImage);
            });
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }
}
