import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/draggable_list.dart';
import 'package:seg_coursework_app/pages/child_board/child_board.dart';
import '../../themes/themes.dart';
import '../../widgets/category_image.dart';
import '../../widgets/category_row.dart';
import '../../widgets/category_title.dart';

class CustomizableRow extends StatelessWidget {
  final String categoryTitle; // e.g. Breakfast
  final List<ClickableImage>
      imagePreviews; // e.g. images of toast, cereal, etc.

  CustomizableRow(
      {Key? key, required this.categoryTitle, required this.imagePreviews})
      : super(key: key);

  // Everything is wrapped in Material() and InkWell() so the onTap gesture shows
  // a simple tap animation

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    return Material(
      color: themeNotifier.getTheme().scaffoldBackgroundColor,
      child: InkWell(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Column of category image and text below it
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryImage(
                      imageLarge: Image.network(imagePreviews[0].imageUrl)),
                  CategoryTitle(title: categoryTitle),
                ],
              ),
              // Row of images within category that wraps should list become too long
              CategoryImageRow(imagePreviews: imagePreviews),
            ],
          ),
        ),
        onTap: () {
          List<ClickableImage> newList = imagePreviews
              .where((x) => imagePreviews.indexOf(x) != 0)
              .toList(); //category image is not an option
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChildBoards(
                        categoryTitle: categoryTitle,
                        categoryImage: imagePreviews[
                            0], //first image forms image of category
                        images: newList,
                      )));
        },
      ),
    );
  }
}
