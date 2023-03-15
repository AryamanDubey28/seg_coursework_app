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
import 'package:flutter/services.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatefulWidget {
  final bool mock;

  CustomizableColumn({this.mock = false});

  @override
  State<CustomizableColumn> createState() => _CustomizableColumnState();
}

class _CustomizableColumnState extends State<CustomizableColumn> {
  TextEditingController pin_controller = TextEditingController();
  late Key key;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    //pin_controller = TextEditingController();
    key = Key("CustomizableColumn");
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(
          () {}); //page updates every 5 seconds therefore gets new data from db every 5 seconds
    });
  }

  @override
  void dispose() {
    pin_controller.dispose();
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
      if (data.length > 1) {
        //only add category if it contains items
        categories.add(data);
      }
    }
    return categories;
  }

  Future openLogoutDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Enter your PIN to go back to the Admin Home"),
            content: TextField(
              key: Key("logoutTextField"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              controller: pin_controller,
            ),
            actions: [
              TextButton(
                  key: Key("submitButton"),
                  onPressed: () => submit(context),
                  child: Text("SUBMIT"))
            ],
          ));

  Future<void> submit(BuildContext context) async {
    //verifys password is correct, if so then navigates back. otherwise says incorrect
    if (!widget.mock) {
      final auth = Auth(auth: FirebaseAuth.instance);
      String currentPin = await auth.getCurrentUserPIN();
      if (pin_controller.text.trim() == currentPin) {
        final pref = await SharedPreferences.getInstance();
        pref.setBool("isInChildMode",
            false); //isInChildMode boolean set to false as we are leaving
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminChoiceBoards(
                    draggableCategories: devCategories,
                  )),
        );
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "Incorrect PIN Provided",
                  textAlign: TextAlign.center,
                ),
              );
            });
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AdminChoiceBoards(
                  draggableCategories: devCategories,
                )),
      );
    }
    pin_controller.clear();
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    if (!widget.mock) {
      FirebaseFunctions firebaseFunctions = FirebaseFunctions(
          auth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
          storage: FirebaseStorage.instance);
      return Scaffold(
        appBar: AppBar(
          title: Text("Child Mode"),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  key: Key("logoutButton"),
                  //only triggers when its pressed for some time and swiped up
                  onLongPressUp: () async {
                    openLogoutDialog(context);
                  },
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ),
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
                itemCount: categories.length,
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
    } else {
      //mocking therefore show base layout
      return Scaffold(
        appBar: AppBar(
          title: Text("Child Mode"),
          automaticallyImplyLeading: false,
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            return CustomizableRow(
              key: Key("row$index"),
              categoryTitle: rowConfigs[index]['categoryTitle'],
              imagePreviews: rowConfigs[index]['images'],
            );
          },
          itemCount: rowConfigs.length,
          separatorBuilder: (context, index) {
            return Divider(height: 2);
          },
        ),
      );
    }

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
