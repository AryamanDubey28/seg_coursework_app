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
  String categoryTitle;
  ClickableImage categoryImage;
  List<ClickableImage> images = [];

  ChildBoards(
      {Key? key,
      required this.categoryTitle,
      required this.categoryImage,
      required this.images})
      : super(key: key);

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
          getTopMenu(themeNotifier),
          //this method is imported from clickable_image_grid in widgets
          getMainImages(widget.images),
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
                    name: widget.categoryImage.name,
                    imageUrl: widget.categoryImage.imageUrl)),
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
      widget.categoryTitle,
      textAlign: TextAlign.right,
      textScaleFactor: 2,
    );
  }

  // Returns the image for the category on display
  Container getCategoryImage() {
    return Container(
      key: const Key("categoryImage"),
      margin: const EdgeInsets.all(8.0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              widget.categoryImage.imageUrl,
            ),
            fit: BoxFit.cover,
          )),
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
