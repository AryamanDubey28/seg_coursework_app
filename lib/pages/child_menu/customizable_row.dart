import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';
import '../../themes/themes.dart';
import '../../widgets/category/category_image_row.dart';
import '../../widgets/category/category_title.dart';

class CustomizableRow extends StatefulWidget {
  final String categoryTitle; // e.g. Breakfast
  final List<ClickableImage>
      imagePreviews; // e.g. images of toast, cereal, etc.
  final List<ClickableImage> unfilteredImages;

  CustomizableRow(
      {Key? key,
      required this.categoryTitle,
      required this.imagePreviews,
      required this.unfilteredImages})
      : super(key: key);

  @override
  State<CustomizableRow> createState() => _CustomizableRowState();
}

class _CustomizableRowState extends State<CustomizableRow> {
  // Everything is wrapped in Material() and InkWell() so the onTap gesture shows

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    return Material(
      color: themeNotifier.getTheme().scaffoldBackgroundColor,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Column of category image and text below it
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryImage(
                      imageLarge:
                          Image.network(widget.imagePreviews[0].imageUrl)),
                  CategoryTitle(title: widget.categoryTitle),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 15),
                    child: ImageSquare(
                        width: 250,
                        height: 250,
                        image: ImageDetails(
                            name: widget.categoryTitle,
                            imageUrl: widget.imagePreviews[0].imageUrl)),
                  ),
                  CategoryTitle(title: widget.categoryTitle),
                ],
              ),
              // Row of images within category that wraps should list become too long
              CategoryImageRow(imagePreviews: widget.imagePreviews),
            ],
          ),
        ),
        onTap: () {
          List<ClickableImage> newList = widget.unfilteredImages
              .where((x) => widget.unfilteredImages.indexOf(x) != 0)
              .toList();
          final player = AudioPlayer();
          player.play(AssetSource('category_click.mp3'));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChildBoards(
                        categoryTitle: widget.categoryTitle,
                        categoryImage: widget.imagePreviews[
                            0], //first image forms image of category
                        images: newList,
                      )));
        },
      ),
    );
  }
}
