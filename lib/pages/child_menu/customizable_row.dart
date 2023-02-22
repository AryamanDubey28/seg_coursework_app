import 'package:flutter/material.dart';
import '../../widgets/category_image.dart';
import '../../widgets/category_row.dart';
import '../../widgets/category_title.dart';
import '../child_board/child_board_interface.dart';

class CustomizableRow extends StatelessWidget {
  final String categoryTitle; // e.g. Breakfast
  final List<Widget> imagePreviews; // e.g. images of toast, cereal, etc.

  CustomizableRow({Key? key, required this.categoryTitle, required this.imagePreviews}) : super(key: key);

  var menuColour = Color(0xFFA8D1D1);
  // Everything is wrapped in Material() and InkWell() so the onTap gesture shows
  // a simple tap animation
  @override
  Widget build(BuildContext context) {
    return Material(
      color: menuColour,
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
                  CategoryImage(imageLarge: imagePreviews[0] as Image),
                  CategoryTitle(title: categoryTitle),
                ],
              ),
              // Row of images within category that wraps should list become too long
              CategoryImageRow(imagePreviews: imagePreviews),
            ],
          ),
        ),
        onTap: () {
          // PLACEHOLDER.
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ChildInterface()));
        },
      ),
    );
  }
}
