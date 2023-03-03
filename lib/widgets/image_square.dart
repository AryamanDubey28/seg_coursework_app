import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';

///This widget returns a 4:3 image surrounded by a border. The default width and height can be adjusted depending on implementation.
class ImageSquare extends StatelessWidget {
  const ImageSquare({super.key, required this.image, this.height = 150, this.width = 200});

  final ImageDetails image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.network(
          image.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception,
              StackTrace? stackTrace) {
            return Center(child: Icon(Icons.network_check_rounded, color: Colors.red,));
          },
        ),
      ),
    );
  }
}