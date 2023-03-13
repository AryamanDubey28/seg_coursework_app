import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/edit_choice_board_category.dart';
import 'package:seg_coursework_app/widgets/hero_dialog_route.dart';

/// Uses new category information to edit existing category
class EditCategoryButton extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImageUrl;

  const EditCategoryButton(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImageUrl});

  @override
  State<EditCategoryButton> createState() => _EditCategoryButtonState();
}

class _EditCategoryButtonState extends State<EditCategoryButton> {
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
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return EditChoiceBoardCategory(
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
          categoryImageUrl: widget.categoryImageUrl);
    }));
  }
}
