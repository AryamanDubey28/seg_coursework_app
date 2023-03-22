import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/pages/child/child_main_menu.dart';
import 'package:seg_coursework_app/helpers/child_category_detailed_view_helper.dart';
import 'package:seg_coursework_app/widgets/general/image_square.dart';
import '../../themes/themes.dart';

class ChildBoards extends StatefulWidget {
  String categoryTitle;
  String categoryImage;
  List<CategoryItem> images = [];
  late FirebaseAuth? auth;
  late FirebaseFirestore? firebaseFirestore;
  late final FirebaseStorage? storage;
  late final Categories? testCategories;

  ChildBoards({
    Key? key,
    required this.categoryTitle,
    required this.categoryImage,
    required this.images,
    this.auth,
    this.firebaseFirestore,
    this.storage,
    this.testCategories,
  }) : super(key: key);

  @override
  State<ChildBoards> createState() => _ChildBoards();
}

/// The page is for the child to select choice boards
class _ChildBoards extends State<ChildBoards> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  // Method used to build main body
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    return Scaffold(
      body: Center(
        widthFactor: MediaQuery.of(context).size.width,
        heightFactor: MediaQuery.of(context).size.height,
        child: Column(children: [
          //box for spacing
          const SizedBox(
            height: 30,
          ),
          Padding(
              padding: const EdgeInsets.all(18.0),
              child: getTopMenu(themeNotifier)),
          //this method is imported from clickable_image_grid in widgets
          getMainImages(widget.images),
        ]),
      ),
    );
  }

  // Method used to get top menu which has back button, category name and image
  Container getTopMenu(CustomTheme themeNotifier) {
    return Container(
        key: const Key("boardMenu"),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: themeNotifier.getTheme().appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            getBackButton(themeNotifier),
            //box for spacing
            const SizedBox(
              width: 30,
            ),
            // Category Image
            ImageSquare(
                key: const Key("categoryImage"),
                width: 90,
                height: 90,
                image: ImageDetails(
                    name: widget.categoryTitle,
                    imageUrl: widget.categoryImage)),
            //box for spacing
            const SizedBox(
              width: 30,
            ),
            getCategoryTitle(),
          ],
        ));
  }

  // Returns category title that shows on menu
  Text getCategoryTitle() {
    return Text(
      key: const Key("categoryTitle"),
      widget.categoryTitle,
      textAlign: TextAlign.right,
      textScaleFactor: 2,
    );
  }

  // Returns round back button that shows on menu
  Container getBackButton(CustomTheme themeNotifier) {
    return Container(
      key: const Key("backButton"),
      margin: const EdgeInsets.all(8.0),
      height: 80,
      width: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(width: 3),
          color: themeNotifier
              .getTheme()
              .floatingActionButtonTheme
              .backgroundColor,
          borderRadius: BorderRadius.circular(100)),
      child: IconButton(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          iconSize: 50,
          hoverColor: Colors.transparent,
          onPressed: () {
            final player = AudioPlayer();
            player.play(AssetSource('back_button.mp3'));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildMainMenu(
                    firebaseFirestore: widget.firebaseFirestore,
                    auth: widget.auth,
                    storage: widget.storage,
                    testCategories: widget.testCategories),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_rounded)),
    );
  }
}
