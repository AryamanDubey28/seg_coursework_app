import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/categoryItem/image_square.dart';

import '../../themes/themes.dart';

///This widget builds a timetable with the arrows to be shown in the visual timetable page.
///Not to be confused with TimetableRow which is shown in the all saved timetables page.
class TimetableList extends StatefulWidget {
  TimetableList({super.key, required this.imagesList, required this.popImagesList});

  final List<ImageDetails> imagesList;
  final Function popImagesList;

  @override
  State<TimetableList> createState() => _TimetableListState();
}

class _TimetableListState extends State<TimetableList> {
  //The indices of the crossed out images
  Set<int> crossedOutIndices = {};

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.imagesList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    crossedOutIndices.remove(index);
                  });
                  widget.popImagesList(index);

                  //The logic behind updating the cross locations if an item is removed.
                  Set<int> updatedIndices = {};
                  for (int i in crossedOutIndices) {
                    if (i > index) {
                      updatedIndices.add(i - 1);
                    } else {
                      updatedIndices.add(i);
                    }
                  }
                  crossedOutIndices = updatedIndices;
                  
                },
                onLongPress: () {
                  setState(() {
                    if(crossedOutIndices.contains(index))
                    {
                      crossedOutIndices.remove(index);
                    }
                    else
                    {
                      crossedOutIndices.add(index);
                    }
                  });
                },
                child: Stack(
                  children: <Widget>[
                    ImageSquare(
                      //This width is set to make the image less wide than 1/5 of the screen.
                      width: constraints.maxWidth/6,
                      height: constraints.maxHeight,
                      key: Key('timetableImage$index'),
                      image: widget.imagesList[index],
                    ),
                    if (crossedOutIndices.contains(index))
                      //The cross out design
                      Positioned.fill(
                        child: Container(
                          key: Key("cross$index"),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red.withOpacity(0.5),
                        ),
                        clipBehavior: Clip.hardEdge,
                          child: Center(
                            child: DecoratedIcon(
                              decoration: IconDecoration(border: IconBorder(width: 5)),
                              icon: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: (constraints.maxWidth + constraints.maxHeight)/12,
                              )
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            //This is so there's no arrow after the last picture.
            separatorBuilder: (context, index) {
              bool isWhite = themeNotifier.getTheme().iconTheme.color == Colors.white;
              return DecoratedIcon(
                decoration: IconDecoration(border: IconBorder(width: 5, color: isWhite ? Colors.black : Colors.white)),
                icon: Icon(
                  Icons.arrow_right,
                  size: constraints.maxWidth/35
                )
              );
            },
          ),
        );
      }
    );
  }
}