import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/cache_manager.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/widgets/logout_icon_button.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images

//1st image is category image, ones after are smaller previews

// ignore: must_be_immutable
class ChildMainMenu extends StatefulWidget {
  final bool mock;
  final Categories? testCategories;
  late FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;
  late Completer completer;
  late final FirebaseStorage storage;

  ChildMainMenu(
      {super.key,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firebaseFirestore,
      FirebaseStorage? storage,
      this.testCategories,
      Completer? completer}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    this.completer = completer ?? Completer();
  }
  //testList = passed in testList from constructor but if none is passed it, testList = test_list_clickable_images

  @override
  State<ChildMainMenu> createState() => _ChildMainMenuState(completer);
}

class _ChildMainMenuState extends State<ChildMainMenu> {
  TextEditingController pin_controller = TextEditingController();
  late Key key;
  late Timer timer;

  late final Auth authentitcationHelper;
  late Completer completer;
  late Categories
      _futureUserCategories; // holds the user categories (if not mocking)

  _ChildMainMenuState(this.completer) {}

  @override
  void initState() {
    super.initState();
    key = Key("ChildMainMenu");
    completer = Completer();
    buildCompleter();
    authentitcationHelper =
        Auth(auth: widget.auth, firestore: widget.firebaseFirestore);
    timer = Timer.periodic(const Duration(minutes: 2), (timer) {
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
    completer.complete(loadData());
  }

  Future<List<ChildMenuCategoryRow>> loadData() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firebaseFirestore,
        storage: widget.storage);
    if (widget.testCategories != null) {
      return widget.testCategories!
          .getList()
          .where((category) => category.availability)
          .map(buildCategory)
          .toList();
    } else {
      if (CheckConnection.isDeviceConnected) {
        // The device has internet connection.
        // get the data from Firebase and store in the cache
        _futureUserCategories =
            await firebaseFunctions.downloadUserCategories();
        await CacheManager.storeCategoriesInCache(
            userCategories: _futureUserCategories);
      } else {
        // The device has no internet connection.
        // get the data the cache
        _futureUserCategories = await CacheManager.getUserCategoriesFromCache();
      }
      return _futureUserCategories
          .getList()
          .where((category) => category.availability)
          .map(buildCategory)
          .toList();
    }
  }

  /// Converts a category to DragAndDropList to be shown
  ChildMenuCategoryRow buildCategory(Category category) {
    if (!widget.mock) {
      return ChildMenuCategoryRow(
        key: Key("categoryRow-${category.id}"),
        categoryItems: category.items,
        category: category,
      );
    } else {
      return ChildMenuCategoryRow(
          key: Key("categoryRow-${category.id}"),
          categoryItems: category.items,
          category: category,
          firebaseFirestore: widget.firebaseFirestore,
          storage: widget.storage,
          auth: widget.auth,
          testCategories: testCategories);
    }
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
            ? loadData()
            : completer
                .future, //retrieves a list from the database of categories and items associated with the category

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChildMenuCategoryRow> categoriesData =
                snapshot.data as List<ChildMenuCategoryRow>;
            return ListView(
              padding: const EdgeInsets.all(2),
              children: categoriesData,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
