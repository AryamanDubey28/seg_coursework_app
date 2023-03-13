import 'package:flutter/material.dart';
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

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imagesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.popImagesList(index);
            setState(() {
              _selectedIndices.remove(index);
            });
          },
          onLongPressUp: () {
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
          child: Row(
            children: <Widget>[
              Tooltip(
                message: widget.imagesList[index].name,
                child: Stack(
                  children: [
                    ImageSquare(
                      //This width is set to make the image less wide than 1/5 of the screen.
                      width: MediaQuery.of(context).size.width/6,
                      key: Key('timetableImage$index'),
                      image: widget.imagesList[index],
                    ),
                    if (_selectedIndices.contains(index))
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.width/6,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              //this is to prevent showing an arrow after the last image.
              if (index != widget.imagesList.length - 1)
                //size is set to this arbitrary number to scale the arrows as the screen gets bigger.
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    (themeNotifier.getTheme().iconTheme.color == Colors.white) ?
                      Icon(Icons.arrow_right, size: MediaQuery.of(context).size.width/35, color: Colors.black,)
                      :
                      Icon(Icons.arrow_right, size: MediaQuery.of(context).size.width/35, color: Colors.white,),
                    
                    Icon(Icons.arrow_right, size: MediaQuery.of(context).size.width/35-10),
                    
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}