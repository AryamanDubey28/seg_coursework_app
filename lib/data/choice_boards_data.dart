import 'package:seg_coursework_app/models/draggable_list.dart';

// These are added to test while development
// They will later be supplied from the database (TO BE DELETED)
final List<DraggableList> devCategories = [
  DraggableList(title: "Breakfast", id: "BLShyb4fzW9V1ZeN7KEB", imageUrl: "https://img.delicious.com.au/bQjDG77i/del/2021/07/spiced-peanut-butter-and-honey-pancakes-with-blackberry-cream-155151-2.jpg", items: [
    DraggableListItem(availability: true, id: "SUXyjNw1J3xPaBKORftQ", name: "Toast", imageUrl: "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
    DraggableListItem(availability: false, id: "cmT3Q83n5g5JxNu6VJny", name: "Fruits", imageUrl: "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"),
  ]),
  DraggableList(id: "Qn6XzuTVTWNQDj90RlHI", title: "Activities", imageUrl: "https://busyteacher.org/uploads/posts/2014-03/1394546738_freetime-activities.png", items: [DraggableListItem(availability: false, id: "mGbQqDre2OB7AFFAJyhy", name: "Football", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"), DraggableListItem(availability: true, id: "B6w5pJHrhSEXSH9AlT2c", name: "Boxing", imageUrl: "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"), DraggableListItem(availability: true, id: "cYswc07Yj5WM8f6ulJRc", name: "Swimming", imageUrl: "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg")]),
  DraggableList(id: "wT9cgT3Xp3viIWJAEFQf", title: "Lunch", imageUrl: "https://static.standard.co.uk/s3fs-public/thumbnails/image/2019/02/18/16/hawksmoor-express-lunch-1802a.jpg?width=968", items: [
    DraggableListItem(availability: true, id: "ltoYr8ZclDSKdfmd0ODo", name: "Butter chicken", imageUrl: "https://www.cookingclassy.com/wp-content/uploads/2021/01/butter-chicken-4.jpg"),
    // DraggableListItem(
    //     availability: true,
    //     id: "placeholder",
    //     name: "Fish and chips",
    //     imageUrl:
    //         "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg"),
    // DraggableListItem(
    //     availability: true,
    //     id: "placeholder",
    //     name: "burgers",
    //     imageUrl:
    //         "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg")
  ]),
];

/// Used for Testing classes
final List<DraggableList> testCategories = [
  DraggableList(title: "Breakfast", id: "0", imageUrl: "breakfast.jpg", items: [DraggableListItem(availability: true, id: "1", name: "Toast", imageUrl: "Toast.jpg"), DraggableListItem(availability: true, id: "2", name: "Fruits", imageUrl: "Fruits.png")]),
  DraggableList(id: "3", title: "Activities", imageUrl: "Activities.png", items: [
    DraggableListItem(availability: true, id: "4", name: "Football", imageUrl: "Football.jpg"),
  ])
];
