import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/timetable.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

import '../themes/themes.dart';

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
  Set<int> _selectedIndices = {};

  // This function returns the list of images already saved in the timetable.
  List<ImageDetails> getImagesList()
  {
    return widget.imagesList;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);
    final isLandscapeMode = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imagesList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              _selectedIndices.remove(index);
            });
            widget.popImagesList(index);

            Set<int> updatedIndices = Set<int>();
            for (int i in _selectedIndices) {
              if (i > index) {
                updatedIndices.add(i - 1);
              } else {
                updatedIndices.add(i);
              }
            }
            _selectedIndices = updatedIndices;
            
          },
          onLongPress: () {
            setState(() {
              if(_selectedIndices.contains(index))
              {
                _selectedIndices.remove(index);
              }
              else
              {
                _selectedIndices.add(index);
              }
            });
          },
          child: Stack(
            children: <Widget>[
              ImageSquare(
                //This width is set to make the image less wide than 1/5 of the screen.
                width: MediaQuery.of(context).size.width/6,
                height: isLandscapeMode? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.height/6.4,
                key: Key('timetableImage$index'),
                image: widget.imagesList[index],
              ),
              if (_selectedIndices.contains(index))
                Positioned.fill(
                  child: Container(
                    key: Key("cross$index"),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red.withOpacity(0.5),
                  ),
                  width: MediaQuery.of(context).size.width/6,
                  height: isLandscapeMode? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.height/6.4,
                  clipBehavior: Clip.hardEdge,
                    child: Center(
                      child: DecoratedIcon(
                        decoration: IconDecoration(border: IconBorder(width: 5)),
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: (MediaQuery.of(context).size.width + 200)/12,
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
            size: MediaQuery.of(context).size.width/35
          )
        );
      },
    );
  }
}