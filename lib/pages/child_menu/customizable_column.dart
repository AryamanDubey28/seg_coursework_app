import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/services/image_controller.dart';
import '../../services/storage_service.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatelessWidget {
  // List of categories, their titles, and images within them
  final Auth auth = Auth(auth: FirebaseAuth.instance);

  //build a list of sets [{_,_} , {_,_}, etc] from devCategories
  List getImagesFromDevCategories() {
    List categoriesAndImages = [];
    for (DraggableList list in devCategories) {
      List category = [];
      var image = ClickableImage(
          name: list.title, imageUrl: list.imageUrl, is_available: true);
      category.add(image);

      for (DraggableListItem item in list.items) {
        var image = ClickableImage(
            name: item.name,
            imageUrl: item.imageUrl,
            is_available: item.availability);
        category.add(image);
      }
      var pair = {list.title, category};
      categoriesAndImages.add(pair);
    }
    return categoriesAndImages;
  }

  List<ClickableImage> buildImageList(List categories, int index) {
    List<ClickableImage> imageList = [];
    List elem = categories[index].elementAt(1);

    for (var e in elem) {
      imageList.add(e as ClickableImage);
    }

    return imageList;
  }

  Future<List<ClickableImage>> readCategoriesList() async {
    //uid = rJftxnUCvmZaeHsh5ZWzlUfyUhX2
    User? user = await auth.getCurrentUser();
    String uid = user!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .orderBy("rank")
        .where("userId", isEqualTo: uid)
        .get();
    print(snapshot);
    List<ClickableImage> data =
        snapshot.docs.map((e) => ClickableImage.fromSnapshot(e)).toList();
    print(data);
    return data;
  }

  ClickableImage buildClickableImage(Map<String, dynamic> data) {
    return ClickableImage(
        name: data["title"],
        imageUrl: data["illustration"],
        is_available: data["is_available"]);
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    List categories = getImagesFromDevCategories();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                //readCategoriesList();
                print("start");
                List<ClickableImage> list = await readCategoriesList();
                print("list = $list");
              },
              icon: Icon(Icons.radio_button_checked))
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          List<ClickableImage> imageList = buildImageList(categories, index);
          return CustomizableRow(
            key: Key("row$index"),
            categoryTitle: categories[index].elementAt(0),
            imagePreviews: imageList,
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
