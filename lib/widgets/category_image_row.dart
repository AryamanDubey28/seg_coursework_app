// List of image previews that belong to a category
import 'package:flutter/material.dart';

class CategoryImageRow extends StatelessWidget {
  final List<Widget> imagePreviews;

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
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: (image as Image).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
