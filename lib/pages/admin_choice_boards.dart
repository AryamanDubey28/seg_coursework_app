import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

class AdminChoiceBoards extends StatefulWidget {
  const AdminChoiceBoards({Key? key}) : super(key: key);

  @override
  State<AdminChoiceBoards> createState() => _AdminChoiceBoards();
}

// The page for admins to edit choice boards
class _AdminChoiceBoards extends State<AdminChoiceBoards> {
  // To be deleted
  final List<DraggableList> testCategories = [
    DraggableList(title: "Breakfast", items: [
      DraggableListItem(
          name: "Toast", imageUrl: "https://picsum.photos/250?image=9"),
      DraggableListItem(
          name: "Fruits", imageUrl: "https://picsum.photos/250?image=9")
    ]),
    DraggableList(title: "Activities", items: [
      DraggableListItem(
          name: "Football", imageUrl: "https://picsum.photos/250?image=9"),
      DraggableListItem(
          name: "Swimming", imageUrl: "https://picsum.photos/250?image=9")
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
          children: categories,
          onItemReorder: onReorderCategoryItem,
          onListReorder: onReorderCategory,
        ));
  }

  DragAndDropList buildCategory(DraggableList category) => DragAndDropList(
      header: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            category.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
      children: category.items
          .map((item) => DragAndDropItem(
                  child: ListTile(
                leading: Image.network(
                  item.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(item.name),
              )))
          .toList());

  void onReorderCategoryItem(int oldItemIndex, int oldCategoryIndex,
      int newItemIndex, int newCategoryIndex) {}

  void onReorderCategory(int oldCategoryIndex, int newCategoryIndex) {}
}
