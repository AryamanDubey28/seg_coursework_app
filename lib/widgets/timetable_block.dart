import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

class TimetableBlock extends StatelessWidget {
  const TimetableBlock({super.key, required this.image, required this.height, required this.width});

  final ImageDetails image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget> [
        ImageSquare(image: image,),
        const Icon(
          Icons.arrow_right_alt_sharp,
          size: 50,
        )
      ],
      
    );
  }
}