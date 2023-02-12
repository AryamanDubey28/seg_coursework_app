/// A model which holds classes to make draggable categories of card boards

class DraggableList {
  final String title;
  final String imageUrl;
  final List<DraggableListItem> items;

  DraggableList(
      {required this.title, required this.items, required this.imageUrl});
}

class DraggableListItem {
  final String name;
  final String imageUrl;

  DraggableListItem({required this.name, required this.imageUrl});
}
