import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/widgets/logout_icon_button.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images

//1st image is category image, ones after are smaller previews

class CustomizableColumn extends StatefulWidget {
  final bool mock;
  static int customizableColumnRequestCounter = 0; //used for testing only
  late List<Map<ClickableImage, List<ClickableImage>>>
      testList; //used for testing only
  late FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;
  late Completer _completer;

  CustomizableColumn({
    this.mock = false,
    FirebaseAuth? auth,
    FirebaseFirestore? firebaseFirestore,
    Completer? completer,
    List<Map<ClickableImage, List<ClickableImage>>>? list,
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
    List<Map<ClickableImage, List<ClickableImage>>> testList = widget.testList;
    completer = Completer();
    buildCompleter();
    authentitcationHelper = Auth(auth: auth, firestore: firebaseFirestore);
    timer = Timer.periodic(Duration(minutes: 2), (timer) {
      setState(
          () {}); //page updates every 2 mins therefore gets new data from db every 2 mins
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Child Mode"),
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
      //getListFromChoiceBoards updates from Firestore but when testing it will cause tester.pumpAndSettle() to time out, completer.future will allow tests to work perfectly but won't allow to have updates from the db. To achieve the best of both worlds, both are here in a ternary operator
      body: FutureBuilder(
        future: !widget.mock
            ? getListFromChoiceBoards()
            : completer
                .future, //retrieves a list from the database of categories and items associated with the category

        builder: (context, snapshot) {
          CustomizableColumn
              .customizableColumnRequestCounter++; //used for testing
          if (snapshot.hasData) {
            List<Map<ClickableImage, List<ClickableImage>>> categoryData =
                snapshot.data
                    as List<Map<ClickableImage, List<ClickableImage>>>;

            List<Map<ClickableImage, List<ClickableImage>>> filtered =
                filterImages(categoryData);

            return ListView.separated(
              itemBuilder: (context, index) {
                ClickableImage dataCategoryKey = filtered[index].keys.first;

                return CustomizableRow(
                  key: Key("row$index"),
                  categoryTitle: dataCategoryKey.name,
                  imagePreviews: filtered[index][dataCategoryKey]!,
                  unfilteredImages: categoryData[index][dataCategoryKey]!,
                  imageLarge: dataCategoryKey,
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
