import 'package:flutter/material.dart';

class CustomizableColumn extends StatelessWidget {
  final List<Map<String, dynamic>> rowConfigs;

  const CustomizableColumn({Key? key, required this.rowConfigs}) : super(key: key);

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
  final String categoryTitle;
  final List<Widget> images;

  const CustomizableRow({Key? key, required this.categoryTitle, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFA8D1D1),
      child: InkWell(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
          print("${categoryTitle} tapped");
        },
      ),
    );
  }
}
