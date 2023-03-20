import 'dart:async';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  static int customizableColumnRequestCounter = 0; //used for testing only
  late List<List<ClickableImage>> testList; //used for testing only
  late FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;
  late Completer _completer;

  CustomizableColumn({
    this.mock = false,
    FirebaseAuth? auth,
    FirebaseFirestore? firebaseFirestore,
    Completer? completer,
    List<List<ClickableImage>>? list,
  }) {
    // testList = testList ?? test_list_clickable_images;
    testList = list ?? test_list_clickable_images;
    this.auth = auth ?? FirebaseAuth.instance;
    this.firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
    this._completer = completer ?? Completer();
  }
  //testList = passed in testList from constructor but if none is passed it, testList = test_list_clickable_images

  @override
  State<CustomizableColumn> createState() =>
      _CustomizableColumnState(auth, firebaseFirestore, _completer);
}

class _CustomizableColumnState extends State<CustomizableColumn> {
  TextEditingController pin_controller = TextEditingController();
  late Key key;
  late Timer timer;
  late FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;
  late final Auth authentitcationHelper;
  late Completer completer;

  _CustomizableColumnState(this.auth, this.firebaseFirestore, this.completer);

  @override
  void initState() {
    super.initState();
    key = Key("CustomizableColumn");
    List<List<ClickableImage>> testList = widget.testList;
    completer = Completer();
    buildCompleter();
    authentitcationHelper = Auth(auth: auth, firestore: firebaseFirestore);
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(
          () {}); //page updates every 4 seconds therefore gets new data from db every 5 seconds
    });
  }

  @override
  void dispose() {
    pin_controller.dispose();
    super.dispose();
    timer
        .cancel(); //cancels timer so it does not keep refreshing in the background
  }

  void buildCompleter() {
    if (widget.mock) {
      completer.complete(widget.testList);
    } else {
      completer.complete(getListFromChoiceBoards());
    }
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
      if (data.length > 1) {
        filteredImages.add(data);
      }
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
                  onPressed: () => submitPin(context),
                  child: Text("SUBMIT"))
            ],
          ));

  Future<void> submitPin(BuildContext context) async {
    //verifys password is correct, if so then navigates back. otherwise says incorrect
    String currentPin = await authentitcationHelper.getCurrentUserPIN();

    if (pin_controller.text.trim() == currentPin) {
      // final pref = await SharedPreferences.getInstance();
      // pref.setBool("isInChildMode",
      //     false); //isInChildMode boolean set to false as we are leaving
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AdminChoiceBoards(
                  mock: widget.mock,
                  auth: widget.auth,
                  firestore: widget.firebaseFirestore,
                  storage: widget.mock ? MockFirebaseStorage() : null,
                ),
            maintainState: false),
      );
      final pref = await SharedPreferences.getInstance();
      pref.setBool("isInChildMode", false);
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
    pin_controller.clear();
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    print("in build");

    return Scaffold(
      appBar: AppBar(
        title: Text("Child Mode"),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                key: Key("logoutButton"),
                //only triggers when its pressed for some time
                onLongPress: () async {
                  openLogoutDialog(context);
                },
                onTap: () async {
                  if (widget.mock) {
                    openLogoutDialog(context); //widget tester can only tap
                  }
                },
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: FutureBuilder(
        // future:
        //     getListFromChoiceBoards(), //retrieves a list from the database of categories and items associated with the category
        future: completer.future,
        builder: (context, snapshot) {
          CustomizableColumn
              .customizableColumnRequestCounter++; //used for testing
          if (snapshot.hasData) {
            print("snapshot data so completer stuff = ${snapshot.data}");
            List<List<ClickableImage>> categories =
                snapshot.data as List<List<ClickableImage>>;
            print("-----------> in CC build's body, list = $categories");
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
              itemCount: filtered.length,
              separatorBuilder: (context, index) {
                return Divider(height: 2);
              },
            );
          } else {
            print("-----> snapshot has no data");
            print(
                "----------------> completer = $completer . completes = ${completer.future}");
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
