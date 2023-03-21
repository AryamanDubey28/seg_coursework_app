// List of image previews that belong to a category
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';

class CategoryImageRow extends StatelessWidget {
  final List<ClickableImage> imagePreviews;

  const CategoryImageRow({
    super.key,
    required this.imagePreviews,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        spacing: 0,
        runSpacing: 0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: imagePreviews
            .sublist(1)
            .map((image) => Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
                child: ImageSquare(
                    height: 110,
                    width: 110,
                    image: ImageDetails(
                        name: "Placeholder", imageUrl: image.imageUrl))))
            .toList(),
      ),
    );
  }
}
