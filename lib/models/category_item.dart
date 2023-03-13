import 'package:flutter/material.dart';

/// A datatype model which mimics a 'CategoryItems' entry in Firestore
class CategoryItem {
  final bool availability;
  final String name;
  final String imageUrl;
  final String id;
  final int rank;
  final Key? key;

  CategoryItem(
      {required this.availability,
      required this.name,
      required this.rank,
      required this.imageUrl,
      required this.id,
      this.key});

  /// Convert a CategoryItem back from json data
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      availability: json['availability'] as bool,
      name: json['name'] as String,
      rank: json['rank'] as int,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
    );
  }

  /// Convert the current CategoryItem to json data
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
