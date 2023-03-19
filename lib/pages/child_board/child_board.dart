import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/categoryItem/clickable_images_grid.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';

import '../../themes/themes.dart';

class ChildBoards extends StatefulWidget {
  // UNCOMMENT AFTER ADDING A QUEERY TO GET IMAGES
  // String categoryTitle;
  // ClickableImage categoryImage;
  // List<ClickableImage> images = [];
  const ChildBoards({Key? key}) : super(key: key);
  // UNCOMMENT AFTER ADDING A QUEERY TO GET IMAGES, THIS SHOULD BE THE FUNCTION \/ DELETE THE CODE ABOVE
  // const ChildBoards({Key? key, required this.categoryTitle, required this.categoryImage, required this.images}) : super(key: key);

  @override
  State<ChildBoards> createState() => _ChildBoards();
}

/// The page is for the child to select choice boards
class _ChildBoards extends State<ChildBoards> with TickerProviderStateMixin {
  // These are added to test while development
  // They will later be supplied from the database (TO BE DELETED)

  // DELETE AFTER ADDING A QUEERY TO GET IMAGES
  final FlutterTts flutterTts = FlutterTts();
  final ClickableImage categoryImage = ClickableImage(
      name: "Toast",
      imageUrl:
          "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg",
      is_available: true);
  final List<ClickableImage> images = [
    ClickableImage(
        name: "Toast",
        imageUrl:
            "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg",
        is_available: false),
    ClickableImage(
        name: "Fruits",
        imageUrl:
            "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80",
        is_available: true),
    ClickableImage(
        name: "Football",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg",
        is_available: false),
    ClickableImage(
        name: "Boxing",
        imageUrl:
            "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325",
        is_available: true),
    ClickableImage(
        name: "Swimming",
        imageUrl:
            "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg",
        is_available: false),
    ClickableImage(
        name: "Butter chicken",
        imageUrl:
            "https://www.cookingclassy.com/wp-content/uploads/2021/01/butter-chicken-4.jpg",
        is_available: false),
    ClickableImage(
        name: "Fish and chips",
        imageUrl:
            "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg",
        is_available: true),
    ClickableImage(
        name: "burgers",
        imageUrl:
            "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg",
        is_available: true),
  ];
  // DELETE DOWN TO HERE

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
          getTopMenu(themeNotifier),
          //this method is imported from clickable_image_grid in widgets
          getMainImages(images),
        ]),
      ),
    );
  }

  // Method used to get top menu which has back button, category name and image
  Padding getTopMenu(CustomTheme themeNotifier) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
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
                    name: categoryImage.name,
                    imageUrl: categoryImage.imageUrl)),
            //box for spacing
            const SizedBox(
              width: 30,
            ),
            getCategoryTitle(),
          ],
        ),
      ),
    );
  }

  // Returns category title that shows on menu
  Text getCategoryTitle() {
    return Text(
      key: const Key("categoryTitle"),
      categoryImage.name,
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded)),
    );
  }
}
