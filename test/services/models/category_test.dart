import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/models/category_item.dart';

/// Tests for the "category.dart" model.
/// The fromJson method is tested with "categories.dart" tests
/// because it can't be accessed outside the class, and is only used by
/// "Categories.dart"
void main() {
  late Category userCategory;
  late Map<String, dynamic> userCategoryJson;

  /// Creates a Category dataset to test with
  Category _createTestCategory() {
    return Category(
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
        ]);
  }

  /// Create a Category as json data to test
  Map<String, dynamic> _createTestCategoryJsonData() {
    return {
      'title': 'Breakfast',
      'rank': 0,
      'items': [
        {
          'availability': true,
          'name': 'Toast',
          'rank': 0,
          'imageUrl': 'Toast.jpg',
          'id': '1'
        },
        {
          'availability': true,
          'name': 'Fruits',
          'rank': 1,
          'imageUrl': 'Fruits.png',
          'id': '2'
        }
      ],
      'imageUrl': 'breakfast.jpg',
      'id': '0',
      'availability': true
    };
  }

  setUp(() {
    userCategory = _createTestCategory();
    userCategoryJson = _createTestCategoryJsonData();
  });

  test("equality operator works successfully", () {
    Category identicalUserCategory = _createTestCategory();
    expect((identicalUserCategory == userCategory), isTrue);
  });

  test("toJson converts a Category to json data successfully", () {
    expect(userCategory.toJson(), userCategoryJson);
  });
}
