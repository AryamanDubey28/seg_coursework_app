/// A model which holds classes to make draggable categories of card boards
import 'dart:convert';

class Categories {
  List<DraggableList> categories;

  Categories({required this.categories});

  void add(DraggableList list) {
    categories.add(list);
  }

  List<DraggableList> getList() {
    return categories;
  }

  factory Categories.fromJson(Map<String, dynamic> json) {
    final categories = (json['categories'] as List<dynamic>)
        .map((e) => DraggableList.fromJson(e as Map<String, dynamic>))
        .toList();
    return Categories(categories: categories);
  }

  Map<String, dynamic> toJson() {
    final categories = this.categories.map((e) => e.toJson()).toList();
    return {'categories': categories};
  }

  Categories fromJsonString(String jsonString) {
    return Categories.fromJson(json.decode(jsonString));
  }

  String toJsonString(Categories categories) {
    return json.encode(categories.toJson());
  }
}

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

  factory DraggableList.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map((e) => DraggableListItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return DraggableList(
      title: json['title'] as String,
      rank: json['rank'] as int,
      items: items,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
      availability: json['availability'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final items = this.items.map((e) => e.toJson()).toList();
    return {
      'title': title,
      'rank': rank,
      'items': items,
      'imageUrl': imageUrl,
      'id': id,
      'availability': availability,
    };
  }
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

  factory DraggableListItem.fromJson(Map<String, dynamic> json) {
    return DraggableListItem(
      availability: json['availability'] as bool,
      name: json['name'] as String,
      rank: json['rank'] as int,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availability': availability,
      'name': name,
      'rank': rank,
      'imageUrl': imageUrl,
      'id': id,
    };
  }
}
