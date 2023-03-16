import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/category.dart';

// These are added to test while development
final List<Category> devCategories = [
  Category(
      title: "Breakfast",
      id: "YYTURkIV6tr90ickFM0F",
      availability: true,
      rank: 0,
      imageUrl:
          "https://img.delicious.com.au/bQjDG77i/del/2021/07/spiced-peanut-butter-and-honey-pancakes-with-blackberry-cream-155151-2.jpg",
      items: [
        CategoryItem(
            availability: true,
            rank: 0,
            id: "Eaawa8YiQRaTYnXmcJNp",
            name: "Toast",
            imageUrl:
                "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
        CategoryItem(
            availability: false,
            rank: 1,
            id: "Eaawa8YiQRaTYnXmcJNp",
            name: "Fruits",
            imageUrl:
                "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"),
      ]),
  Category(
      id: "vvKsFHrHvkP1SL8MlWKk",
      rank: 1,
      title: "Activities",
      availability: true,
      imageUrl:
          "https://busyteacher.org/uploads/posts/2014-03/1394546738_freetime-activities.png",
      items: [
        CategoryItem(
            availability: false,
            rank: 0,
            id: "Eaawa8YiQRaTYnXmcJNp",
            name: "Football",
            imageUrl:
                "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"),
        CategoryItem(
            availability: true,
            rank: 1,
            id: "BMjvuL6OwtVjGbk9QoNg",
            name: "Boxing",
            imageUrl:
                "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"),
        CategoryItem(
            availability: true,
            rank: 2,
            id: "Qg40XVwilis4XRAL6hwI",
            name: "Swimming",
            imageUrl:
                "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg")
      ]),
  Category(
      id: "JSgepdChaNV0hCMGDrIb",
      rank: 2,
      title: "Lunch",
      availability: true,
      imageUrl:
          "https://static.standard.co.uk/s3fs-public/thumbnails/image/2019/02/18/16/hawksmoor-express-lunch-1802a.jpg?width=968",
      items: [
        CategoryItem(
            availability: true,
            rank: 0,
            id: "placeholder",
            name: "Butter chicken",
            imageUrl:
                "https://www.cookingclassy.com/wp-content/uploads/2021/01/butter-chicken-4.jpg"),
        CategoryItem(
            availability: true,
            rank: 1,
            id: "placeholder",
            name: "Fish and chips",
            imageUrl:
                "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg"),
        CategoryItem(
            availability: true,
            rank: 2,
            id: "placeholder",
            name: "burgers",
            imageUrl:
                "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg")
      ]),
];

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
