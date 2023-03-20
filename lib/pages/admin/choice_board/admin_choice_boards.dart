import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_read_functions.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_update_functions.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/services/loadingMixin.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/delete_category_button.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/delete_item_button.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/edit_category_button.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/add_item_button.dart';
import 'package:seg_coursework_app/widgets/general/loading_indicator_variation.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/admin_switch_buttons.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/edit_item_button.dart';
import 'package:seg_coursework_app/widgets/admin_timetable/image_square.dart';
import '../admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/add_category_button.dart';

/* 
* The implementation of the draggable lists is made with the help
* of https://youtu.be/HmiaGyf55ZM
*/
// The AdminChoiceBoard is the admin's main view that enables him/her to see the categories and items
// that exist in the system. To edit, reorder, and delete them as well as to switch the categories' and items'
// availabilities.
class AdminChoiceBoard extends StatefulWidget {
  final Categories? testCategories;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final bool mock;

  AdminChoiceBoard(
      {super.key,
      this.testCategories,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<AdminChoiceBoard> createState() => _AdminChoiceBoard();
}

/// The page for admins to edit choice boards
class _AdminChoiceBoard extends State<AdminChoiceBoard>
    with LoadingMixin<AdminChoiceBoard> {
  late List<DragAndDropList> categories = [];
  late Categories
      _futureUserCategories; // holds the user categories (if not mocking)

  @override
  Future<void> load() async {
    FirebaseReadFunctions firebaseReadFunctions = FirebaseReadFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);

    if (widget.testCategories != null) {
      categories = widget.testCategories!.getList().map(buildCategory).toList();
    } else {
      _futureUserCategories = await firebaseReadFunctions.getUserCategories();
      categories = _futureUserCategories.getList().map(buildCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          key: Key('app_bar'),
          title: const Text('Loading Choice Boards'),
        ),
        drawer: const AdminSideMenu(),
        body: CustomLoadingIndicator(),
      );
    } else if (hasError) {
      return AlertDialog(
        content: Text(
            'An error occurred while communicating with the database. \nPlease retry.'),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminChoiceBoard()));
            },
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          key: Key('app_bar'),
          title: const Text('Edit Choice Boards'),
        ),
        drawer: const AdminSideMenu(),
        floatingActionButton: AddCategoryButton(
          mock: widget.mock,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: DragAndDropLists(
          listPadding: const EdgeInsets.all(30),
          listInnerDecoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20)),
          children: categories,
          contentsWhenEmpty: Text(
              "Welcome! Click on \"Add a category\" to start",
              style: TextStyle(fontSize: 30)),
          itemDivider: const Divider(
            thickness: 4,
            height: 4,
            color: Colors.black12,
          ),
          listDragHandle: buildDragHandle(isCategory: true),
          itemDragHandle: buildDragHandle(),
          onItemReorder: onReorderCategoryItem,
          onListReorder: onReorderCategory,
        ),
      );
    }
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

  /// Converts a category to DragAndDropList to be shown
  DragAndDropList buildCategory(Category category) => DragAndDropList(
      // Category details
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
              const Padding(padding: EdgeInsets.only(right: 6)),
              Text(
                category.title,
                key: Key("categoryTitle-${category.id}"),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              DeleteCategoryButton(
                  mock: widget.mock,
                  categoryId: category.id,
                  categoryName: category.title,
                  categoryImage: category.imageUrl),
              EditCategoryButton(
                  mock: widget.mock,
                  categoryId: category.id,
                  categoryName: category.title,
                  categoryImageUrl: category.imageUrl),
              AvailabilitySwitchToggle(
                mock: widget.mock,
                documentId: category.id,
                documentAvailability: category.availability,
                isCategory: true,
                key: Key("categorySwitchButton-${category.id}"),
                auth: widget.auth,
                firestore: widget.firestore,
                storage: widget.storage,
              ),
              const Spacer(),
              AddItemButton(
                mock: widget.mock,
                categoryId: category.id,
                key: Key("addItemButton-${category.id}"),
                auth: widget.auth,
                firestore: widget.firestore,
                storage: widget.storage,
              ),
              const Padding(padding: EdgeInsets.only(right: 35))
            ],
          )),
      // Category items details
      children: category.items.isEmpty
          // Empty category
          ? [
              DragAndDropItem(
                  child: Center(
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    Text(
                      "Empty category! Click on \"Add an item\" to start",
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))
            ]
          // Non-empty category
          : category.items
              .map((item) => DragAndDropItem(
                      child: ListTile(
                    key: Key("categoryItem-${item.id}"),
                    leading: ImageSquare(
                      image: ImageDetails(
                          name: item.name, imageUrl: item.imageUrl),
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
                        AvailabilitySwitchToggle(
                          mock: widget.mock,
                          documentId: item.id,
                          documentAvailability: item.availability,
                          isCategory: false,
                          key: Key("itemSwitchButton-${item.id}"),
                          auth: widget.auth,
                          firestore: widget.firestore,
                          storage: widget.storage,
                        ),
                        DeleteItemButton(
                          mock: widget.mock,
                          categoryId: category.id,
                          itemId: item.id,
                          itemName: item.name,
                          key: Key("deleteItemButton-${item.id}"),
                          auth: widget.auth,
                          firestore: widget.firestore,
                          storage: widget.storage,
                        ),
                        EditItemButton(
                          mock: widget.mock,
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
    if (newCategoryIndex == oldCategoryIndex) {
      FirebaseUpdateFunctions firebaseUpdateFunctions = FirebaseUpdateFunctions(
          auth: widget.auth,
          firestore: widget.firestore,
          storage: widget.storage);
      Categories userCategories =
          widget.testCategories ?? _futureUserCategories;

      final trigger = await firebaseUpdateFunctions.saveCategoryItemOrder(
          categoryId: userCategories.getList().elementAt(oldCategoryIndex).id,
          oldItemIndex: oldItemIndex,
          newItemIndex: newItemIndex);
      if (trigger) {
        setState(() {
          final selectedItem =
              categories[oldCategoryIndex].children.removeAt(oldItemIndex);
          categories[oldCategoryIndex]
              .children
              .insert(newItemIndex, selectedItem);

          final selectedItemDrag = userCategories
              .getList()[oldCategoryIndex]
              .children
              .removeAt(oldItemIndex);
          userCategories
              .getList()[oldCategoryIndex]
              .children
              .insert(newItemIndex, selectedItemDrag);
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
  }

  /// The logic behind reordering a category
  void onReorderCategory(int oldCategoryIndex, int newCategoryIndex) async {
    FirebaseUpdateFunctions firebaseUpdateFunctions = FirebaseUpdateFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
    Categories userCategories = widget.testCategories ?? _futureUserCategories;

    final trigger = await firebaseUpdateFunctions.saveCategoryOrder(
        oldRank: oldCategoryIndex, newRank: newCategoryIndex);
    if (trigger) {
      setState(() {
        final selectedCategory = categories.removeAt(oldCategoryIndex);
        categories.insert(newCategoryIndex, selectedCategory);

        final dragList = userCategories.getList().removeAt(oldCategoryIndex);
        userCategories.getList().insert(newCategoryIndex, dragList);
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
}
