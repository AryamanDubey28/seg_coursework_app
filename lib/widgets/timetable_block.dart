import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

class TimetableBlock extends StatelessWidget {
  const TimetableBlock({super.key, required this.imageURL, required this.height, required this.width});

  final String imageURL;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget> [
        ImageSquare(imageURL: imageURL, height: height, width: width,),
        const Icon(
          Icons.arrow_right_alt_sharp,
          size: 50,
        )
      ],
      
    );
  }
}