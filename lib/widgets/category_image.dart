// Large category image
import 'package:flutter/material.dart';

class CategoryImage extends StatelessWidget {
  final Image imageLarge;

  const CategoryImage({
    super.key,
    required this.imageLarge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(30, 30, 30, 15),
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              image: DecorationImage(
                image: imageLarge.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
