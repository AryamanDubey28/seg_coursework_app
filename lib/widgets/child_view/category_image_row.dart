import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';

/// List of image previews that belong to a category
class CategoryItemsPreview extends StatelessWidget {
  final List<CategoryItem> imagePreviews;

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
            .where((item) => item.availability)
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
