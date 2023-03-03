import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/widgets/delete_category_button.dart';
import 'package:seg_coursework_app/widgets/edit_category_button.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:seg_coursework_app/widgets/add_category_button.dart';

/* 
* The implementation of the draggable lists is made with the help
* of https://youtu.be/HmiaGyf55ZM
*/

class AdminChoiceBoards extends StatefulWidget {
  const AdminChoiceBoards({Key? key}) : super(key: key);

  @override
  State<AdminChoiceBoards> createState() => _AdminChoiceBoards();
}

/// The page for admins to edit choice boards
class _AdminChoiceBoards extends State<AdminChoiceBoards> {
  late List<DragAndDropList> categories;

  _AdminChoiceBoards() {
    categories = devCategories.map(buildCategory).toList();
  }

  // These are added to test while development
  // They will later be supplied from the database (TO BE DELETED)
  final List<DraggableList> devCategories = [
    DraggableList(
        title: "Breakfast",
        id: "HRbbm0S8hBkXhwIB3nUK",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/seg-app-f4674.appspot.com/o/images%2Fbwekfast1677509161380?alt=media&token=d6355591-241a-4b1e-965a-f4f9ee80b87a",
        items: [
          DraggableListItem(
              id: "placeholder",
              name: "Toast",
              imageUrl:
                  "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
          DraggableListItem(
              id: "placeholder",
              name: "Fruits",
              imageUrl:
                  "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80")
        ]),
    DraggableList(
        id: "vvKsFHrHvkP1SL8MlWKk",
        title: "Activities",
        imageUrl:
            "https://busyteacher.org/uploads/posts/2014-03/1394546738_freetime-activities.png",
        items: [
          DraggableListItem(
              id: "placeholder",
              name: "Football",
              imageUrl:
                  "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"),
          DraggableListItem(
              id: "placeholder",
              name: "Boxing",
              imageUrl:
                  "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"),
          DraggableListItem(
              id: "placeholder",
              name: "Swimming",
              imageUrl:
                  "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg")
        ]),
    DraggableList(
        id: "JSgepdChaNV0hCMGDrIb",
        title: "Lunch",
        imageUrl:
            "https://static.standard.co.uk/s3fs-public/thumbnails/image/2019/02/18/16/hawksmoor-express-lunch-1802a.jpg?width=968",
        items: [
          DraggableListItem(
              id: "vvUA1y2roERdElRjzfhy",
              name: "Oak Sauce",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/seg-app-f4674.appspot.com/o/images%2FOk%20Sauce1677270717787?alt=media&token=b678e93e-e1b1-4b28-9aeb-227696d0c00b"),
          DraggableListItem(
              id: "placeholder",
              name: "Butter chicken",
              imageUrl:
                  "https://www.cookingclassy.com/wp-content/uploads/2021/01/butter-chicken-4.jpg"),
          DraggableListItem(
              id: "placeholder",
              name: "Fish and chips",
              imageUrl:
                  "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg"),
          DraggableListItem(
              id: "placeholder",
              name: "burgers",
              imageUrl:
                  "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg")
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key('app_bar'),
        title: const Text('Edit Choice Boards'),
      ),
      drawer: const AdminSideMenu(),
      floatingActionButton: AddCategoryButton(),
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
          padding: const EdgeInsets.only(right: 10, top: 45),
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

  /// Builds the edit button depending on if it's an item or a category
  IconButton buildEditButton({bool isCategory = false}) {
    const editIcon = Icon(
      Icons.edit,
      color: Color.fromARGB(255, 0, 76, 153),
    );

    return IconButton(
      key: const Key("editItemButton"),
      onPressed: editItem,
      icon: editIcon,
      padding: const EdgeInsets.only(right: 45),
    );
  }

  /// Builds the add button
  TextButton buildAddButton() {
    const addIcon = Icon(
      Icons.add,
    );

    if (isCategory) {
      return TextButton.icon(
        key: const Key("addCategoryButton"),
        onPressed: addCategory,
        icon: addIcon,
        label: const Text("Add a category"),
      );
    } else {
      return TextButton.icon(
        key: const Key("addItemButton"),
        onPressed: addItem,
        icon: addIcon,
        label: const Text("Add an item"),
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
      key: const Key("deleteButton"),
      onPressed: deleteCategory,
      icon: deleteIcon,
    );
  }

  /// Converts a category from DraggableList to DragAndDropList to be shown
  DragAndDropList buildCategory(DraggableList category) => DragAndDropList(
      header: Container(
          key: const Key("categoryHeader"),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Image.network(
                  category.imageUrl,
                  key: const Key("categoryImage"),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('!Error loading image!');
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                category.title,
                key: const Key("categoryTitle"),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              DeleteCategoryButton(categoryId: category.id),
              EditCategoryButton(
                  categoryId: category.id,
                  categoryName: category.title,
                  categoryImageUrl: category.imageUrl),
              const Spacer(),
              buildAddButton(),
              const Padding(padding: EdgeInsets.only(right: 35))
            ],
          )),
      children: category.items
          .map((item) => DragAndDropItem(
                  child: ListTile(
                key: const Key("categoryItem"),
                leading: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 5,
                  child: Image.network(
                    item.imageUrl,
                    key: const Key("itemImage"),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Text('!Error loading image!');
                    },
                  ),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(color: Colors.black),
                  key: const Key("itemTitle"),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Delete item button goes here?
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

  /// deletes the item (to be implemented)
  void deleteItem() {}

  /// redirects to the item add page (to be implemented)
  void addItem() {}
}
