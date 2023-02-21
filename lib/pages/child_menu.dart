import 'package:flutter/material.dart';
import 'child_board/child_board_interface.dart';

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

class CustomizableRow extends StatelessWidget {
  final String categoryTitle; // e.g. Breakfast
  final List<Widget> imagePreviews; // e.g. images of toast, cereal, etc.

  CustomizableRow({Key? key, required this.categoryTitle, required this.imagePreviews}) : super(key: key);

  var menuColour = Color(0xFFA8D1D1);
  // Everything is wrapped in Material() and InkWell() so the onTap gesture shows
  // a simple tap animation
  @override
  Widget build(BuildContext context) {
    return Material(
      color: menuColour,
      child: InkWell(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Column of category image and text below it
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryImage(imageLarge: imagePreviews[0] as Image),
                  CategoryTitle(title: categoryTitle),
                ],
              ),
              // Row of images within category that wraps should list become too long
              CategoryImageRow(imagePreviews: imagePreviews),
            ],
          ),
        ),
        onTap: () {
          // PLACEHOLDER.
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ChildInterface()));
        },
      ),
    );
  }
}

// Large category image
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

// Category title that appears under main category image
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
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

// List of image previews that belong to a category
class CategoryImageRow extends StatelessWidget {
  final List<Widget> imagePreviews;

  const CategoryImageRow({
    super.key,
    required this.imagePreviews,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        spacing: 0,
        runSpacing: 0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: imagePreviews
            .sublist(1)
            .map((image) => Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: (image as Image).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
