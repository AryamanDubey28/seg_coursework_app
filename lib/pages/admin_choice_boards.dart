import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

/* 
* The implementation of the draggable lists is made with the help
* of https://youtu.be/HmiaGyf55ZM
*/

// Add images to categories
// Button to delete category
// Button to delete item
// Button to edit category
// Button to edit item
// Button to add category
// Button to add item

class AdminChoiceBoards extends StatefulWidget {
  const AdminChoiceBoards({Key? key}) : super(key: key);

  @override
  State<AdminChoiceBoards> createState() => _AdminChoiceBoards();
}

/// The page for admins to edit choice boards
class _AdminChoiceBoards extends State<AdminChoiceBoards> {
  // To be deleted
  final List<DraggableList> testCategories = [
    DraggableList(title: "Breakfast", items: [
      DraggableListItem(
          name: "Toast",
          imageUrl:
              "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
      DraggableListItem(
          name: "Fruits",
          imageUrl:
              "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80")
    ]),
    DraggableList(title: "Activities", items: [
      DraggableListItem(
          name: "Football",
          imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"),
      DraggableListItem(
          name: "Boxing",
          imageUrl:
              "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"),
      DraggableListItem(
          name: "Swimming",
          imageUrl:
              "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg")
    ]),
    DraggableList(title: "Lunch", items: [
      DraggableListItem(
          name: "Butter chicken",
          imageUrl:
              "https://www.cookingclassy.com/wp-content/uploads/2021/01/butter-chicken-4.jpg"),
      DraggableListItem(
          name: "Fish and chips",
          imageUrl:
              "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg"),
      DraggableListItem(
          name: "burgers",
          imageUrl:
              "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg")
    ]),
  ];

  late List<DragAndDropList> categories;

  @override
  void initState() {
    super.initState();
    categories = testCategories.map(buildCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Choice Boards'),
        ),
        drawer: const AdminSideMenu(),
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
        ));
  }

  /// Builds the dragging icon depending on if it's an item or a category
  DragHandle buildDragHandle({bool isCategory = false}) {
    final verticalAlignment = isCategory
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;

    final dragColor = isCategory ? Colors.black87 : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.menu,
          color: dragColor,
        ),
      ),
    );
  }

  /// Converts a category from DraggableList to DragAndDropList to be shown
  DragAndDropList buildCategory(DraggableList category) => DragAndDropList(
      header: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            category.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
      children: category.items
          .map((item) => DragAndDropItem(
                  child: ListTile(
                leading: Image.network(
                  item.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('!Error loading image!');
                  },
                ),
                title: Text(item.name),
              )))
          .toList());

  /// The logic behind reordering an item
  void onReorderCategoryItem(int oldItemIndex, int oldCategoryIndex,
      int newItemIndex, int newCategoryIndex) {
    setState(() {
      final selectedItem =
          categories[oldCategoryIndex].children.removeAt(oldItemIndex);
      categories[newCategoryIndex].children.insert(newItemIndex, selectedItem);
    });
  }

  /// The logic behind reordering a category
  void onReorderCategory(int oldCategoryIndex, int newCategoryIndex) {
    setState(() {
      final selectedCategory = categories.removeAt(oldCategoryIndex);
      categories.insert(newCategoryIndex, selectedCategory);
    });
  }
}
