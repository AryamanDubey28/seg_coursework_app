import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/category.dart';

/// Used for Testing classes
final Categories testCategories = Categories(categories: categories);

final List<Category> categories = [
  Category(
      title: "Breakfast",
      rank: 0,
      id: "0",
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/some-bucket/o/imagesBreakfast",
      availability: true,
      items: [
        CategoryItem(
            availability: true,
            id: "1",
            rank: 0,
            name: "Toast",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/some-bucket/o/imagesToast"),
        CategoryItem(
            availability: true,
            id: "2",
            rank: 1,
            name: "Fruits",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/some-bucket/o/imagesFruits")
      ]),
  Category(
      id: "3",
      rank: 1,
      title: "Activities",
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/some-bucket/o/imagesActivities",
      availability: true,
      items: [
        CategoryItem(
            availability: true,
            rank: 0,
            id: "4",
            name: "Football",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/some-bucket/o/imagesFootball"),
      ])
];
