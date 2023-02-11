import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';

class ImageSquare extends StatelessWidget {
  const ImageSquare({super.key, required this.image, required this.height, required this.width});

  final ImageDetails image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 5),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(image.imageUrl)
        )
      ),
      // child: Image.network(imageURL),
    );
  }
}