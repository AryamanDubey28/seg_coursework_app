import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/add_choice_board_item.dart';
import 'package:seg_coursework_app/widgets/hero_dialog_route.dart';

/// The button in the Admin Choice Boards page to add
/// a new item to a category
class AddItemButton extends StatefulWidget {
  final String categoryId;

  const AddItemButton({super.key, required this.categoryId});

  @override
  State<AddItemButton> createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: addItem,
      icon: Icon(Icons.add),
      label: const Text("Add an item"),
      style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(Colors.white),
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 105, 187, 123))),
    );
  }

  /// open the add item popup (Add choice board item page)
  void addItem() {
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return AddChoiceBoardItem(
        categoryId: widget.categoryId,
        key: Key("addItemHero-${widget.categoryId}"),
      );
    }));
  }
}
