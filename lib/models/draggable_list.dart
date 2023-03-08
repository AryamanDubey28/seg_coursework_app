/// A model which holds classes to make draggable categories of card boards

class DraggableList {
  final bool availability;
  final String title;
  final String imageUrl;
  final String id;
  final int rank;
  final List<DraggableListItem> items;

  DraggableList(
      {required this.title,
      required this.rank,
      required this.items,
      required this.imageUrl,
      required this.id,
      required this.availability});
}

class DraggableListItem {
  final bool availability;
  final String name;
  final String imageUrl;
  final String id;
  final int rank;

  DraggableListItem(
      {required this.availability,
      required this.name,
      required this.rank,
      required this.imageUrl,
      required this.id});
}
