import 'package:flutter/material.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatelessWidget {
  // const CustomizableColumn({Key? key, required this.rowConfigs}) : super(key: key);

  // List of categories, their titles, and images within them
  final List<Map<String, dynamic>> rowConfigs = [
    {
      'categoryTitle': 'Category 1',
      'images': [
        Image.asset("test/assets/test_image.png", fit: BoxFit.fill),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
      ],
    },
    {
      'categoryTitle': 'Category 2',
      'images': [
        Image.asset("test/assets/test_image.png", fit: BoxFit.fill),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
      ],
    },
    {
      'categoryTitle': 'Category 3',
      'images': [
        Image.asset("test/assets/test_image.png", fit: BoxFit.fill),
        Image.asset("test/assets/test_image.png"),
      ],
    },
  ];

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
          return CustomizableRow(
            categoryTitle: rowConfigs[index]['categoryTitle'],
            imagePreviews: rowConfigs[index]['images'],
          );
        },
        itemCount: rowConfigs.length,
        separatorBuilder: (context, index) {
          return Divider(height: 2);
        },
      ),
    );
  }
}
