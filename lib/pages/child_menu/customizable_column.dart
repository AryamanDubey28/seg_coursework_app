import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/image_controller.dart';
import '../../services/storage_service.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatelessWidget {
  // List of categories, their titles, and images within them

  //build a list of sets [{_,_} , {_,_}, etc] from devCategories
  List getImagesFromDevCategories() {
    List categoriesAndImages = [];
    for (DraggableList list in devCategories) {
      List category = [];
      var image = ClickableImage(
          name: list.title, imageUrl: list.imageUrl, is_available: true);
      //category.add(Image.network(list.imageUrl));
      category.add(image);
      for (DraggableListItem item in list.items) {
        //category.add(Image.network(item.imageUrl));
        var image = ClickableImage(
            name: item.name, imageUrl: item.imageUrl, is_available: true);
        category.add(image);
      }
      var pair = {list.title, category};
      categoriesAndImages.add(pair);
    }
    return categoriesAndImages;
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    List categories = getImagesFromDevCategories();
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return CustomizableRow(
            key: Key("row$index"),
            categoryTitle: categories[index].elementAt(0),
            imagePreviews: categories[index].elementAt(1),
          );
        },
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return Divider(height: 2);
        },
      ),
    );
  }
}
