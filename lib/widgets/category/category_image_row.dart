// List of image previews that belong to a category
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';

class CategoryItemsPreview extends StatelessWidget {
  final List<ClickableImage> imagePreviews;

  const CategoryItemsPreview({
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
            .where((item) => item.is_available)
            .map((item) => Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
                child: ImageSquare(
                    height: 110,
                    width: 110,
                    image: ImageDetails(imageUrl: item.imageUrl))))
            .toList(),
      ),
    );
  }
}
