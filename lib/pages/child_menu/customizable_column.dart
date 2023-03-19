import 'dart:async';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';

import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import '../../helpers/firebase_functions.dart';
import '../../models/categories.dart';
import 'package:flutter/services.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images

class CustomizableColumn extends StatefulWidget {
  final bool mock;
  static int customizableColumnRequestCounter = 0; //used for testing
  List<List<ClickableImage>> testList; //used for testing
  CustomizableColumn({this.mock = false, testList})
      : testList = testList ??
            test_list_clickable_images; //testList = passed in testList from constructor but if none is passed it, testList = test_list_clickable_images

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
    timer
        .cancel(); //cancels timer so it does not keep refreshing in the background
  }

  List<List<ClickableImage>> filterImages(List<List<ClickableImage>> list) {
    List<List<ClickableImage>> filteredImages = [];
    for (List sub_list in list) {
      List<ClickableImage> data = [];
      for (ClickableImage item in sub_list) {
        if (item.is_available) {
          data.add(item);
        }
      }
      filteredImages.add(data);
    }
    return filteredImages;
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
      final auth = Auth(
          auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
      String currentPin = await auth.getCurrentUserPIN();
      if (pin_controller.text.trim() == currentPin) {
        final pref = await SharedPreferences.getInstance();
        pref.setBool("isInChildMode",
            false); //isInChildMode boolean set to false as we are leaving
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminChoiceBoards(), maintainState: false),
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
      if (pin_controller.text.trim() == "0000") {
        MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
        FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
        MockFirebaseStorage mockFirebaseStorage = MockFirebaseStorage();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminChoiceBoards(
                    firestore: fakeFirebaseFirestore,
                    auth: mockFirebaseAuth,
                    storage: mockFirebaseStorage,
                  )),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminChoiceBoards()),
        );
      }
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
        body: FutureBuilder(
          future:
              getListFromChoiceBoards(), //retrieves a list from the database of categories and items associated with the category
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<List<ClickableImage>> categories =
                  snapshot.data as List<List<ClickableImage>>;
              List<List<ClickableImage>> filtered = filterImages(categories);
              return ListView.separated(
                itemBuilder: (context, index) {
                  return CustomizableRow(
                    key: Key("row$index"),
                    categoryTitle: filtered[index][0].name,
                    imagePreviews: filtered[index],
                    unfilteredImages: categories[index],
                  );
                },
                itemCount: categories.length,
                separatorBuilder: (context, index) {
                  return Divider(height: 2);
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    } else {
      //mocking therefore show base layout
      List<List<ClickableImage>> mockingList = widget.testList;
      CustomizableColumn.customizableColumnRequestCounter++;
      return Scaffold(
        appBar: AppBar(
          title: Text("Child Mode"),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  key: Key("logoutButton"),
                  //widget tester cannot hold
                  onTap: () async {
                    openLogoutDialog(context);
                  },
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            if (mockingList[index].length > 1) {
              return CustomizableRow(
                key: Key("row$index"),
                categoryTitle: mockingList[index][0].name,
                imagePreviews: mockingList[index],
                unfilteredImages: mockingList[index],
              );
            }
          },
          itemCount: mockingList.length,
          separatorBuilder: (context, index) {
            return Divider(height: 2);
          },
        ),
      );
    }
  }
}
