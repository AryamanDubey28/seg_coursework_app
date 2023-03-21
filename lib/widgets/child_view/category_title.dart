// Category title that appears under main category image
import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final String title;

  const CategoryTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontFamily: 'Poppins',
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
