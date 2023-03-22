import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/models/category_item.dart';

/// Tests for the "categories.dart" model.
/// toJson and fromJson are used in the fromJsonString and toJsonString
/// so they are not tested individually
void main() {
  late Categories userCategories;
  late String userCategoriesJsonString;

  /// Creates a Categories dataset to test with
  Categories _createTestCategories() {
    List<Category> categoriesList = [
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

    return Categories(categories: categoriesList);
  }

  /// Create a Categories as a json string to test
  String _createTestCategoriesJsonString() {
    return "{\"categories\":[{\"title\":\"Breakfast\",\"rank\":0,\"items\":[{\"availability\":true,\"name\":\"Toast\",\"rank\":0,\"imageUrl\":\"Toast.jpg\",\"id\":\"1\"},{\"availability\":true,\"name\":\"Fruits\",\"rank\":1,\"imageUrl\":\"Fruits.png\",\"id\":\"2\"}],\"imageUrl\":\"breakfast.jpg\",\"id\":\"0\",\"availability\":true},{\"title\":\"Activities\",\"rank\":1,\"items\":[{\"availability\":true,\"name\":\"Football\",\"rank\":0,\"imageUrl\":\"Football.jpg\",\"id\":\"4\"}],\"imageUrl\":\"Activities.png\",\"id\":\"3\",\"availability\":true}]}";
  }

  setUp(() {
    userCategories = _createTestCategories();
    userCategoriesJsonString = _createTestCategoriesJsonString();
  });

  test("add method adds a category successfully", () {
    expect(userCategories.getList().length, 2);
    userCategories.add(Category(
        title: "Sports",
        rank: 2,
        items: [],
        imageUrl: "sport.jpeg",
        id: '5',
        availability: true));

    expect(userCategories.getList().length, 3);
  });

  test("equality operator works successfully", () {
    Categories identicalUserCategories = _createTestCategories();
    expect((identicalUserCategories == userCategories), isTrue);
  });

  test("toJsonString converts Categories to json string successfully", () {
    expect(
        userCategories.toJsonString(userCategories), userCategoriesJsonString);
  });

  test(
      "toJsonString converts an empty Categories to an empty Categories string",
      () {
    expect(userCategories.toJsonString(Categories(categories: [])),
        '{"categories":[]}');
  });

  test(
      "fromJsonString converts a json string to a Categories object successfully",
      () {
    expect(userCategories.fromJsonString(userCategoriesJsonString),
        userCategories);
  });

  test(
      "fromJsonString converts an empty Categories json string to a Categories object successfully",
      () {
    expect(userCategories.fromJsonString('{"categories":[]}'),
        Categories(categories: []));
  });
}
