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
import 'package:seg_coursework_app/widgets/logout_icon_button.dart';
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
    widget.mock
        ? completer.complete(widget.testList)
        : completer.complete(getListFromChoiceBoards());
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    //buildCompleter();
    return Scaffold(
      appBar: AppBar(
        title: Text("Child Mode"),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: LogoutIconButton(
                key: Key("logoutIcon"),
                mock: widget.mock,
                pin_controller: pin_controller,
                authenticationHelper: authentitcationHelper),
          )
        ],
      ),
      body: FutureBuilder(
        future: !widget
                .mock //getListFromChoiceBoards updates from Firestore but when testing it will cause tester.pumpAndSettle() to time out, completer.future will allow tests to work perfectly but won't allow to have updates from the db. To achieve the best of both worlds, both are here in a ternary operator
            ? getListFromChoiceBoards()
            : completer
                .future, //retrieves a list from the database of categories and items associated with the category

        //future: completer.future,

        //future: getListFromChoiceBoards(),

        builder: (context, snapshot) {
          CustomizableColumn
              .customizableColumnRequestCounter++; //used for testing
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
              itemCount: filtered.length,
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
  }
}
