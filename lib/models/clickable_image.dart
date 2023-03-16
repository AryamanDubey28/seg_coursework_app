import 'package:cloud_firestore/cloud_firestore.dart';

/// A model which holds the class to make clickable images on the child board

class ClickableImage {
  final String name;
  final String imageUrl;
  final bool is_available;

  ClickableImage(
      {required this.name, required this.imageUrl, required this.is_available});

  factory ClickableImage.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return ClickableImage(
        name: data["title"],
        imageUrl: data["illustration"],
        is_available: data["is_available"]);
  }
}
