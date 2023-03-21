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

List<Map<ClickableImage, List<ClickableImage>>> filterImages(
    List<Map<ClickableImage, List<ClickableImage>>> list) {
  List<Map<ClickableImage, List<ClickableImage>>> filtered = [];
  for (Map<ClickableImage, List<ClickableImage>> entry in list) {
    Map<ClickableImage, List<ClickableImage>> map = {};
    ClickableImage key = entry.keys.first;
    List<ClickableImage> list = [];
    for (ClickableImage image in entry[key]!) {
      if (image.is_available) {
        list.add(image);
      }
    }
    map[key] = list;
    if (list.length > 0) {
      filtered.add(map);
    }
  }
  return filtered;
}

Future<List<Map<ClickableImage, List<ClickableImage>>>>
    getListFromChoiceBoards() async {
  FirebaseFunctions firebaseFunctions = FirebaseFunctions(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance);
  //[ {category} : [items, items, items] ,   ]

  Categories futureUserCategories =
      await firebaseFunctions.downloadUserCategories();
  List<Map<ClickableImage, List<ClickableImage>>> categories = [];
  for (var category in futureUserCategories.getList()) {
    if (category.availability) {
      Map<ClickableImage, List<ClickableImage>> data = {};
      List<ClickableImage> valueList = [];
      for (var item in category.items) {
        valueList.add(buildClickableImageFromCategoryItem(item));
      }
      data[buildClickableImageFromCategory(category)] = valueList;
      if (valueList.length > 0) {
        categories.add(data);
      }
    }
  }
  print("returning $categories");
  return categories;
}

ClickableImage buildClickableImageFromCategory(Category item) {
  return ClickableImage(
      name: item.title,
      imageUrl: item.imageUrl,
      is_available: item.availability);
}

ClickableImage buildClickableImageFromCategoryItem(CategoryItem item) {
  return ClickableImage(
      name: item.name,
      imageUrl: item.imageUrl,
      is_available: item.availability);
}

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
final ClickableImage test_pic1 =
    ClickableImage(name: "pic1", imageUrl: "Toast.jpg", is_available: true);
final ClickableImage test_pic2 =
    ClickableImage(name: "name", imageUrl: "imageUrl", is_available: true);

final List<Map<String, dynamic>> rowConfigs = [
  {
    'categoryTitle': 'Category 1',
    'images': [
      test_pic1,
      test_pic1,
    ],
  },
  {
    'categoryTitle': 'Category 2',
    'images': [
      test_pic1,
      test_pic1,
      test_pic1,
      test_pic1,
    ],
  },
  {
    'categoryTitle': 'Category 3',
    'images': [
      test_pic1,
      test_pic1,
    ],
  },
];

final List<Map<ClickableImage, List<ClickableImage>>>
    test_list_clickable_images = [
  {
    test_pic1: [test_pic1, test_pic2, test_pic1]
  },
  {
    test_pic1: [test_pic1, test_pic2, test_pic1]
  },
  {
    test_pic1: [test_pic1, test_pic2, test_pic1]
  },
];

final List<ClickableImage> imageRow = [
  test_pic1,
  test_pic1,
  test_pic1,
  test_pic1
];

final List<Map<ClickableImage, List<ClickableImage>>>
    test_list_clickable_images_zero = [
  {test_pic1: []}
];
