import 'package:flutter/foundation.dart' as helper;
import 'package:seg_coursework_app/models/category_item.dart';

/// A datatype model which mimics a 'Category' entry in Firestore
class Category {
  final bool availability;
  final String title;
  final String imageUrl;
  final String id;
  final int rank;
  final List<CategoryItem> items;

  Category(
      {required this.title,
      required this.rank,
      required this.items,
      required this.imageUrl,
      required this.id,
      required this.availability});

  get children => items;

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is Category &&
        other.availability == availability &&
        other.title == title &&
        other.imageUrl == imageUrl &&
        other.id == id &&
        other.rank == rank &&
        helper.listEquals(other.items, items);
  }

  @override
  int get hashCode => Object.hash(
      availability, title, imageUrl, id, rank, Object.hashAll(items));

  /// Convert a Category back from json data
  factory Category.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return Category(
      title: json['title'] as String,
      rank: json['rank'] as int,
      items: items,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
      availability: json['availability'] as bool,
    );
  }

  /// Convert the current Category to json data
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
