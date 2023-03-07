import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/widgets/admin_switch.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/add_item_button.dart';
import 'package:seg_coursework_app/widgets/delete_item_button.dart';
import 'package:seg_coursework_app/widgets/edit_item_button.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';

/* 
* The implementation of the draggable lists is made with the help
* of https://youtu.be/HmiaGyf55ZM
*/

class AdminChoiceBoards extends StatefulWidget {
  final List<DraggableList> draggableCategories;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  AdminChoiceBoards(
      {super.key,
      required this.draggableCategories,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<AdminChoiceBoards> createState() => _AdminChoiceBoards();
}

/// The page for admins to edit choice boards
class _AdminChoiceBoards extends State<AdminChoiceBoards> {
  late List<DragAndDropList> categories;
  late FirebaseFunctions firebaseFunctions;

  @override
  void initState() {
    super.initState();
    categories = widget.draggableCategories.map(buildCategory).toList();
    firebaseFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key('app_bar'),
        title: const Text('Edit Choice Boards'),
      ),
      drawer: const AdminSideMenu(),
      floatingActionButton: buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: DragAndDropLists(
        listPadding: const EdgeInsets.all(30),
        listInnerDecoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)),
        children: categories,
        itemDivider: const Divider(
          thickness: 2,
          height: 2,
          color: Colors.black12,
        ),
        listDragHandle: buildDragHandle(isCategory: true),
        itemDragHandle: buildDragHandle(),
        onItemReorder: onReorderCategoryItem,
        onListReorder: onReorderCategory,
      ),
    );
  }

  /// Builds the dragging icon depending on if it's an item or a category
  DragHandle buildDragHandle({bool isCategory = false}) {
    final dragColor = isCategory ? Colors.black87 : Colors.black26;
    final dragIcon = Icon(
      Icons.menu,
      color: dragColor,
    );

    if (isCategory) {
      return DragHandle(
        key: const Key("categoryDrag"),
        verticalAlignment: DragHandleVerticalAlignment.top,
        child: Container(
          padding: const EdgeInsets.only(right: 10, top: 55),
          child: dragIcon,
        ),
      );
    } else {
      return DragHandle(
        key: const Key("itemDrag"),
        verticalAlignment: DragHandleVerticalAlignment.center,
        child: Container(
          padding: const EdgeInsets.only(right: 10),
          child: dragIcon,
        ),
      );
    }
  }

  /// Builds the edit button for a category
  IconButton buildEditButton({Key? key}) {
    const editIcon = Icon(
      Icons.edit,
      color: Color.fromARGB(255, 0, 76, 153),
    );

    return IconButton(
      key: key,
      onPressed: editCategory,
      icon: editIcon,
      alignment: Alignment.centerRight,
    );
  }

  /// Builds the add button for categories
  TextButton buildAddButton() {
    return TextButton.icon(
      key: const Key("addCategoryButton"),
      onPressed: addCategory,
      icon: Icon(Icons.add),
      label: const Text("Add a category"),
    );
  }

  /// Builds the delete button
  IconButton buildDeleteButton({Key? key}) {
    const deleteIcon = Icon(
      Icons.delete,
      color: Colors.red,
    );

    return IconButton(
      key: key,
      onPressed: deleteCategory,
      icon: deleteIcon,
    );
  }

  /// Converts a category from DraggableList to DragAndDropList to be shown
  DragAndDropList buildCategory(DraggableList category) => DragAndDropList(
      header: Container(
          key: Key("categoryHeader-${category.id}"),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ImageSquare(
                image: ImageDetails(
                    name: category.title, imageUrl: category.imageUrl),
                key: Key("categoryImage-${category.id}"),
                height: 120,
                width: 120,
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                category.title,
                key: Key("categoryTitle-${category.id}"),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              buildDeleteButton(
                  key: Key("deleteCategoryButton-${category.id}")),
              buildEditButton(key: Key("editCategoryButton-${category.id}")),
              const Spacer(),
              AddItemButton(
                categoryId: category.id,
                key: Key("addItemButton-${category.id}"),
                auth: widget.auth,
                firestore: widget.firestore,
                storage: widget.storage,
              ),
              const Padding(padding: EdgeInsets.only(right: 35))
            ],
          )),
      children: category.items
          .map((item) => DragAndDropItem(
                  child: ListTile(
                key: Key("categoryItem-${item.id}"),
                leading: ImageSquare(
                  image: ImageDetails(name: item.name, imageUrl: item.imageUrl),
                  key: Key("itemImage-${item.id}"),
                  height: 90,
                  width: 90,
                ),
                title: Text(
                  item.name,
                  key: Key("itemTitle-${item.id}"),
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchButton(
                      itemId: item.id,
                      itemAvailability: item.availability,
                      key: Key("switchButton-${item.id}"),
                      auth: widget.auth,
                      firestore: widget.firestore,
                      storage: widget.storage,
                    ),
                    DeleteItemButton(
                      categoryId: category.id,
                      itemId: item.id,
                      itemName: item.name,
                      key: Key("deleteItemButton-${item.id}"),
                      auth: widget.auth,
                      firestore: widget.firestore,
                      storage: widget.storage,
                    ),
                    EditItemButton(
                      itemId: item.id,
                      itemName: item.name,
                      itemImageUrl: item.imageUrl,
                      key: Key("editItemButton-${item.id}"),
                      auth: widget.auth,
                      firestore: widget.firestore,
                      storage: widget.storage,
                    ),
                  ],
                ),
              )))
          .toList());

  /// The logic behind reordering an item
  void onReorderCategoryItem(int oldItemIndex, int oldCategoryIndex,
      int newItemIndex, int newCategoryIndex) async {
    setState(() {
      final selectedItem =
          categories[oldCategoryIndex].children.removeAt(oldItemIndex);
      categories[newCategoryIndex].children.insert(newItemIndex, selectedItem);
    });
  }

  /// The logic behind reordering a category
  void onReorderCategory(int oldCategoryIndex, int newCategoryIndex) async {
    final trigger = await firebaseFunctions.saveCategoryOrder(
        categoryIdOne:
            widget.draggableCategories.elementAt(oldCategoryIndex).id,
        categoryIdTwo:
            widget.draggableCategories.elementAt(newCategoryIndex).id);
    if (trigger) {
      setState(() {
        final selectedCategory = categories.removeAt(oldCategoryIndex);
        categories.insert(newCategoryIndex, selectedCategory);

        final dragList = widget.draggableCategories.removeAt(oldCategoryIndex);
        widget.draggableCategories.insert(newCategoryIndex, dragList);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          'Reordering could not be done. Please ensure you are connected to internet.',
        ),
      ));
    }
  }

  /// redirects to the category edit page (to be implemented)
  void editCategory() {}

  /// deletes the category (to be implemented)
  void deleteCategory() {}

  /// redirects to the category add page (to be implemented)
  void addCategory() {}
}
