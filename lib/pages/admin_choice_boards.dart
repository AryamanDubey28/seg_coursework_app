import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

/* 
* The implementation of the draggable lists is made with the help
* of https://youtu.be/HmiaGyf55ZM
*/

// Add cards behind the pictures

class AdminChoiceBoards extends StatefulWidget {
  const AdminChoiceBoards({Key? key}) : super(key: key);

  @override
  State<AdminChoiceBoards> createState() => _AdminChoiceBoards();
}

/// The page for admins to edit choice boards
class _AdminChoiceBoards extends State<AdminChoiceBoards> {
  // To be deleted
  final List<DraggableList> testCategories = [
    DraggableList(
        title: "Breakfast",
        imageUrl:
            "https://img.delicious.com.au/bQjDG77i/del/2021/07/spiced-peanut-butter-and-honey-pancakes-with-blackberry-cream-155151-2.jpg",
        items: [
          DraggableListItem(
              name: "Toast",
              imageUrl:
                  "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
          DraggableListItem(
              name: "Fruits",
              imageUrl:
                  "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80")
        ]),
    DraggableList(
        title: "Activities",
        imageUrl:
            "https://busyteacher.org/uploads/posts/2014-03/1394546738_freetime-activities.png",
        items: [
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
    DraggableList(
        title: "Lunch",
        imageUrl:
            "https://static.standard.co.uk/s3fs-public/thumbnails/image/2019/02/18/16/hawksmoor-express-lunch-1802a.jpg?width=968",
        items: [
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
      floatingActionButton: buildAddButton(isCategory: true),
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
        verticalAlignment: DragHandleVerticalAlignment.top,
        child: Container(
          padding: const EdgeInsets.only(right: 10, top: 30),
          child: dragIcon,
        ),
      );
    } else {
      return DragHandle(
        verticalAlignment: DragHandleVerticalAlignment.center,
        child: Container(
          padding: const EdgeInsets.only(right: 10),
          child: dragIcon,
        ),
      );
    }
  }

  /// Builds the edit button depending on if it's an item or a category
  IconButton buildEditButton({bool isCategory = false}) {
    const editIcon = Icon(
      Icons.edit,
      color: Color.fromARGB(255, 0, 76, 153),
    );

    if (isCategory) {
      return IconButton(
        onPressed: editCategory,
        icon: editIcon,
        alignment: Alignment.centerRight,
      );
    } else {
      return IconButton(
        onPressed: editItem,
        icon: editIcon,
        padding: const EdgeInsets.only(right: 45),
      );
    }
  }

  /// Builds the add button depending on if it's an item or a category
  TextButton buildAddButton({bool isCategory = false}) {
    const addIcon = Icon(
      Icons.add,
    );
    const contentColor = MaterialStatePropertyAll(Colors.white);

    if (isCategory) {
      return TextButton.icon(
        onPressed: addCategory,
        icon: addIcon,
        label: const Text("Add a category"),
        style: const ButtonStyle(
            foregroundColor: contentColor,
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 80, 141, 93))),
      );
    } else {
      return TextButton.icon(
        onPressed: addItem,
        icon: addIcon,
        label: const Text("Add an item"),
        style: const ButtonStyle(
            foregroundColor: contentColor,
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 105, 187, 123))),
      );
    }
  }

  /// Builds the delete button
  IconButton buildDeleteButton() {
    const deleteIcon = Icon(
      Icons.delete,
      color: Colors.red,
    );

    return IconButton(
      onPressed: deleteCategory,
      icon: deleteIcon,
    );
  }

  /// Converts a category from DraggableList to DragAndDropList to be shown
  DragAndDropList buildCategory(DraggableList category) => DragAndDropList(
      header: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.network(
                category.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('!Error loading image!');
                },
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                category.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              buildEditButton(isCategory: true),
              buildDeleteButton(),
              const Spacer(),
              buildAddButton(),
              const Padding(padding: EdgeInsets.only(right: 35))
            ],
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildDeleteButton(),
                    buildEditButton(),
                  ],
                ),
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

  /// redirects to the item edit page (to be implemented)
  void editItem() {}

  /// redirects to the category edit page (to be implemented)
  void editCategory() {}

  /// deletes the item (to be implemented)
  void deleteItem() {}

  /// deletes the category (to be implemented)
  void deleteCategory() {}

  /// redirects to the item add page (to be implemented)
  void addItem() {}

  /// redirects to the category add page (to be implemented)
  void addCategory() {}
}
