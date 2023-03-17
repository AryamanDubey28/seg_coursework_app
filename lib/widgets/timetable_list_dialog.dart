import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/timetable.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

import '../themes/themes.dart';

///This widget builds a timetable with the arrows to be shown in the dialog in the all timetables page.
class TimetableListDialog extends StatefulWidget {
  const TimetableListDialog({super.key, required this.timetable});
  final Timetable timetable;

  @override
  State<TimetableListDialog> createState() => _TimetableListDialogState();
}

class _TimetableListDialogState extends State<TimetableListDialog> {
  Set<int> crossedOutIndices = {};

  // This function returns the list of images already saved in the timetable.
  Timetable getImagesList()
  {
    return widget.timetable;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: (constraints.maxWidth * (5/6) + (constraints.maxWidth/35*4)),
          height: constraints.maxWidth/(widget.timetable.length()+1),
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.timetable.length(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
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
                        //This width is set to make the image change with how big the screen is and how many images
                        width: constraints.maxWidth/(widget.timetable.length()+1),
                        height: constraints.maxHeight,
                        key: Key('timetableDialogImage$index'),
                        image: widget.timetable.get(index),
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
                                  size: (constraints.maxWidth + constraints.maxHeight) / 3 / widget.timetable.length(),
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
          ),
        );
      }
    );
  }
}