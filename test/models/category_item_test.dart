import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/models/category_item.dart';

/// Tests for the "category_item.dart" model.
/// The fromJson method is tested with "categories.dart" tests
/// because it can't be accessed outside the class, and is only used by
/// "Categories.dart"
void main() {
  late CategoryItem userCategoryItem;
  late Map<String, dynamic> userCategoryItemJson;

  /// Creates a Category_item dataset to test with
  CategoryItem _createTestCategoryItem() {
    return CategoryItem(
        availability: true,
        id: "1",
        rank: 0,
        name: "Toast",
        imageUrl: "Toast.jpg");
  }

  /// Create a Category_item as json data to test
  Map<String, dynamic> _createTestCategoryItemJsonData() {
    return {
      'availability': true,
      'name': 'Toast',
      'rank': 0,
      'imageUrl': 'Toast.jpg',
      'id': '1'
    };
  }

  setUp(() {
    userCategoryItem = _createTestCategoryItem();
    userCategoryItemJson = _createTestCategoryItemJsonData();
  });

  test("equality operator works successfully", () {
    CategoryItem identicalUserCategory = _createTestCategoryItem();
    expect((identicalUserCategory == userCategoryItem), isTrue);
  });

  test("toJson converts a CategoryItem to json data successfully", () {
    expect(userCategoryItem.toJson(), userCategoryItemJson);
  });
}
