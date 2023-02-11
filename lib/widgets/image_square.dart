import 'package:flutter/material.dart';

class ImageSquare extends StatelessWidget {
  const ImageSquare({super.key, required this.imageURL, required this.height, required this.width});

  final String imageURL;
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
          image: NetworkImage(imageURL)
        )
      ),
      // child: Image.network(imageURL),
    );
  }
}