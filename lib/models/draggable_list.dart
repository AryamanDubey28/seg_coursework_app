/// A model which holds classes to make draggable categories of card boards
class DraggableList {
  final String title;
  final String imageUrl;
  final String id;
  final List<DraggableListItem> items;

  DraggableList({required this.title, required this.items, required this.imageUrl, required this.id});

  get children => items;
}

class DraggableListItem {
  final bool availability;
  final String name;
  final String imageUrl;
  final String id;

  DraggableListItem({required this.availability, required this.name, required this.imageUrl, required this.id});
}
