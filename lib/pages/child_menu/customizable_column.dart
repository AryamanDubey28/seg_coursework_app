import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/services/image_controller.dart';
import '../../helpers/firebase_functions.dart';
import '../../models/categories.dart';
import '../../services/storage_service.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatefulWidget {
  @override
  State<CustomizableColumn> createState() => _CustomizableColumnState();
}

class _CustomizableColumnState extends State<CustomizableColumn> {
  // List of categories, their titles, and images within them
  final Auth auth = Auth(auth: FirebaseAuth.instance);
  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(
          () {}); //page updates every 5 seconds therefore gets new data from db every 5 seconds
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  List<List<ClickableImage>> getList(Categories futureUserCategories) {
    List<List<ClickableImage>> categories = [];
    for (var category in futureUserCategories.getList()) {
      List<ClickableImage> data = [];
      data.add(buildClickableImageFromCategory(category));
      for (var item in category.items) {
        data.add(buildClickableImageFromCategoryItem(item));
      }
      categories.add(data);
    }
    return categories;
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance);
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: firebaseFunctions
            .getUserCategoriesAsStream(), //retrieves a list from the database of categories and items associated with the category
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Categories temp_categories = snapshot.data as Categories;
            List<List<ClickableImage>> categories = getList(temp_categories);

            return ListView.separated(
              itemBuilder: (context, index) {
                return CustomizableRow(
                  key: Key("row$index"),
                  categoryTitle: categories[index][0].name,
                  imagePreviews: categories[index],
                );
              },
              itemCount: 3,
              separatorBuilder: (context, index) {
                return Divider(height: 2);
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(),
    //   body: StreamBuilder(
    //     stream:
    //         getListFromChoiceBoards(), //retrieves a list from the database of categories and items associated with the category
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         List<List<ClickableImage>> snapshotDataList =
    //             snapshot.data as List<List<ClickableImage>>;
    //         return ListView.separated(
    //           itemBuilder: (context, index) {
    //             return CustomizableRow(
    //               key: Key("row$index"),
    //               categoryTitle: snapshotDataList[index][0].name,
    //               imagePreviews: snapshotDataList[index],
    //             );
    //           },
    //           itemCount: snapshotDataList.length,
    //           separatorBuilder: (context, index) {
    //             return Divider(height: 2);
    //           },
    //         );
    //       } else {
    //         return CircularProgressIndicator();
    //       }
    //     },
    //   ),
    // );
  }
}
