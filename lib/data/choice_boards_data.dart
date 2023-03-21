import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seg_coursework_app/helpers/cache_manager.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';

import '../models/categories.dart';

// These are added to test while development
// They will later be supplied from the database (TO BE DELETED)
final List<Category> categories = [
  Category(
      title: "Breakfast",
      rank: 0,
      id: "0",
      imageUrl: "breakfast.jpg",
      availability: true,
      items: [
        CategoryItem(
            availability: true,
            id: "1",
            rank: 0,
            name: "Toast",
            imageUrl: "Toast.jpg"),
        CategoryItem(
            availability: true,
            id: "2",
            rank: 1,
            name: "Fruits",
            imageUrl: "Fruits.png")
      ]),
  Category(
      id: "3",
      rank: 1,
      title: "Activities",
      imageUrl: "Activities.png",
      availability: true,
      items: [
        CategoryItem(
            availability: true,
            rank: 0,
            id: "4",
            name: "Football",
            imageUrl: "Football.jpg"),
      ])
];

final Categories myTestCategories = Categories(categories: categories);

/// Used for Testing classes
final Categories testCategories = Categories(categories: my_categories);

final List<Category> my_categories = [
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

final Category sampleCategory = categories.first;
