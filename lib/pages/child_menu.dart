import 'package:flutter/material.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatelessWidget {
  final List<Map<String, dynamic>> rowConfigs;

  const CustomizableColumn({Key? key, required this.rowConfigs}) : super(key: key);

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return new Container(
            child: CustomizableRow(
          categoryTitle: rowConfigs[index]['categoryTitle'],
          images: rowConfigs[index]['images'],
        ));
      },
      itemCount: rowConfigs.length,
    );
  }
}

class CustomizableRow extends StatelessWidget {
  final String categoryTitle; // e.g. Breakfast
  final List<Widget> images; // e.g. images of toast, cereal, etc.

  CustomizableRow({Key? key, required this.categoryTitle, required this.images}) : super(key: key);

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
                  // Large category image
                  Row(
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
                              image: (images[0] as Image).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Category title text
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Text(
                          categoryTitle,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Row of images within category that wraps should list become too long
              Expanded(
                child: Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  children: images
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
              ),
            ],
          ),
        ),
        onTap: () {
          // PLACEHOLDER. REDIRECT TO OTHER PAGE
          print("${categoryTitle} tapped");
        },
      ),
    );
  }
}
