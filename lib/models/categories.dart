import 'dart:convert';
import 'package:seg_coursework_app/models/category.dart';

/// A datatype model which holds a list of 'Category'.
/// Essentially, all of the user's choice boards data
class Categories {
  List<Category> categories;

  Categories({required this.categories});

  /// Add a given Category to the back of the list
  void add(Category category) {
    categories.add(category);
  }

  /// Return the data as a list
  List<Category> getList() {
    return categories;
  }

  /// Convert a 'Categories' back from json data
  factory Categories.fromJson(Map<String, dynamic> json) {
    final categories = (json['categories'] as List<dynamic>)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
    return Categories(categories: categories);
  }

  /// Convert the current 'Categories' to json data
  Map<String, dynamic> toJson() {
    final categories = this.categories.map((e) => e.toJson()).toList();
    return {'categories': categories};
  }

  /// Return a 'Categories' from a given json string
  Categories fromJsonString(String jsonString) {
    return Categories.fromJson(json.decode(jsonString));
  }

  /// Convert the current 'Categories' to json string
  String toJsonString(Categories categories) {
    return json.encode(categories.toJson());
  }
}
