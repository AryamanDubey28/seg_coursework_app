class DraggableList {
  final String title;
  final List<DraggableListItem> items;

  DraggableList({required this.title, required this.items});
}

class DraggableListItem {
  final String name;
  final String imageUrl;

  DraggableListItem({required this.name, required this.imageUrl});
}
