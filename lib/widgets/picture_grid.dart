import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

class PictureGrid extends StatelessWidget {
  const PictureGrid({super.key, required this.imagesURL, required this.updateImagesList});

  final List imagesURL;
  final Function updateImagesList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 5,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5
          ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            updateImagesList(imagesURL[index]);
          },
          child: Card(
            child: ImageSquare(
              imageURL: imagesURL[index],
              width: 150,
              height: 150,
            ),
          ),
        );
      }
    );
  }
}