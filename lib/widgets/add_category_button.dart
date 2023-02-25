import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/add_choice_board_category.dart';
import 'package:seg_coursework_app/widgets/hero_dialog_route.dart';

/// The button in the Admin Choice Boards page to add
/// a new item to a category
class AddCategoryButton extends StatefulWidget {
  const AddCategoryButton({super.key});

  @override
  State<AddCategoryButton> createState() => _AddCategoryButtonState();
}

class _AddCategoryButtonState extends State<AddCategoryButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      key: const Key("addCategoryButton"),
      onPressed: addCategory,
      icon: Icon(Icons.add),
      label: const Text("Add a category"),
      style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 80, 141, 93))),
    );
  }

  /// open the add item popup (Add choice board item page)
  void addCategory() {
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return AddChoiceBoardCategory();
    }));
  }
}
