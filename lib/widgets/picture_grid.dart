import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';
import 'package:seg_coursework_app/widgets/search_bar.dart';

/// This widget is the bottom half of the visual timetable interface
/// and it shows a choice board of all the images that are fed into it.
class PictureGrid extends StatefulWidget {
  const PictureGrid(
      {super.key, required this.imagesList, required this.updateImagesList});

  final List<ImageDetails> imagesList;
  final Function updateImagesList;

  @override
  State<PictureGrid> createState() => _PictureGridState();
}

class _PictureGridState extends State<PictureGrid> {
  String _searchText = '';

  ///This function gets the items filtered by the searchbar.
  List<ImageDetails> _getFilteredItems() {
    if (_searchText.isEmpty) {
      return widget
          .imagesList; // the list of all items to be displayed in the grid view
    } else {
      return widget.imagesList
          .where((item) =>
              item.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagesList.isEmpty) {
      return Text("No items to show. Add some in the 'Choice Board' page");
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.fromLTRB(7, 0, 7, 7),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
                child: SearchBar(onTextChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                }),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                //the height of the column minus height of the search bar, the sized box, and the margin.
                height: constraints.maxHeight - 75 - 7,
                child: GridView.builder(
                    itemCount: _getFilteredItems().length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.updateImagesList(_getFilteredItems()[index]);
                        },
                        child: Tooltip(
                          message: _getFilteredItems()[index].name,
                          child: ImageSquare(
                            key: Key('gridImage$index'),
                            image: _getFilteredItems()[index],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      });
    }
  }
}
