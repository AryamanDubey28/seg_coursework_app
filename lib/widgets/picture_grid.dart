import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

class PictureGrid extends StatelessWidget {
  const PictureGrid({super.key, required this.imagesList, required this.updateImagesList});

  final List<ImageDetails> imagesList;
  final Function updateImagesList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imagesList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 4/3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            updateImagesList(imagesList[index]);
          },
          child: Tooltip(
            message: imagesList[index].name,
            child: ImageSquare(
              key: Key('gridImage$index'),
              image: imagesList[index],
            ),
          ),
        );
      }
    );
  }
}