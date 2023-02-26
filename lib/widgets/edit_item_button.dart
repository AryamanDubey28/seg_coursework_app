import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/edit_choice_board_item.dart';
import 'package:seg_coursework_app/widgets/hero_dialog_route.dart';

/// The pen (edit) button for items in the Admin Choice Boards page
class EditItemButton extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemImageUrl;

  const EditItemButton(
      {super.key,
      required this.itemId,
      required this.itemName,
      required this.itemImageUrl});

  @override
  State<EditItemButton> createState() => _EditItemButtonState();
}

class _EditItemButtonState extends State<EditItemButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key("editItemButton-${widget.itemId}"),
      onPressed: editItem,
      icon: Icon(Icons.edit, color: Color.fromARGB(255, 0, 76, 153)),
      padding: const EdgeInsets.only(right: 45),
    );
  }

  /// open the edit item popup (Edit choice board item page)
  void editItem() {
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return EditChoiceBoardItem(
          itemId: widget.itemId,
          itemName: widget.itemName,
          itemImageUrl: widget.itemImageUrl);
    }));
  }
}
