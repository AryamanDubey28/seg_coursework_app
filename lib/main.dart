import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/child_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Create column of rows (categories)
      // Note, until connected to backend, categoryTitle and images take placeholder data
      home: CustomizableColumn(rowConfigs: [
        {
          'categoryTitle': 'Category 1',
          'images': [
            Image.network('https://via.placeholder.com/110', fit: BoxFit.fill),
            Image.network('https://via.placeholder.com/110'),
            Image.network('https://via.placeholder.com/110'),
            Image.network('https://via.placeholder.com/110'),
          ],
        },
        {
          'categoryTitle': 'Category 2',
          'images': [
            Image.network('https://via.placeholder.com/110', fit: BoxFit.fill),
            Image.network('https://via.placeholder.com/110'),
            Image.network('https://via.placeholder.com/110'),
          ],
        },
        {
          'categoryTitle': 'Category 3',
          'images': [
            Image.network('https://via.placeholder.com/110', fit: BoxFit.fill),
            Image.network('https://via.placeholder.com/110'),
            Image.network('https://via.placeholder.com/110'),
            Image.network('https://via.placeholder.com/110'),
            Image.network('https://via.placeholder.com/110'),
          ],
        },
        {
          'categoryTitle': 'Category 4',
          'images': [
            Image.network('https://via.placeholder.com/110', fit: BoxFit.fill),
            Image.network('https://via.placeholder.com/110'),
          ],
        },
      ]),
    );
  }
}
