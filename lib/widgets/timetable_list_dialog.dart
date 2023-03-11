import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/timetable.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

import '../themes/themes.dart';

///This widget builds a timetable with the arrows to be shown in the visual timetable page.
///Not to be confused with TimetableRow which is shown in the all saved timetables page.
class TimetableListDialog extends StatelessWidget {
  const TimetableListDialog({super.key, required this.timetable});

  final Timetable timetable;

  // This function returns the list of images already saved in the timetable.
  Timetable getImagesList()
  {
    return timetable;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: timetable.length(),
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
            Tooltip(
              message: timetable.get(index).name,
              child: ImageSquare(
                //This width is set to make the image less wide than 1/5 of the screen. FIX LATER
                width: MediaQuery.of(context).size.width/(timetable.length()+1),
                height: MediaQuery.of(context).size.height/timetable.length(),
                key: Key('timetableImage$index'),
                image: timetable.get(index),
              ),
            ),
            //this is to prevent showing an arrow after the last image.
            if (index != timetable.length() - 1)
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
        );
      },
    );
  }
}