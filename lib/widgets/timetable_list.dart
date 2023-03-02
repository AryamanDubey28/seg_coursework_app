import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

import '../themes/themes.dart';

///This widget builds a timetable with the arrows to be shown in the visual timetable page.
///Not to be confused with TimetableRow which is shown in the all saved timetables page.
class TimetableList extends StatelessWidget {
  const TimetableList({super.key, required this.imagesList, required this.popImagesList});

  final List<ImageDetails> imagesList;
  final Function popImagesList;

  // This function returns the list of images already saved in the timetable.
  List<ImageDetails> getImagesList()
  {
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<CustomTheme>(context);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imagesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            popImagesList(index);
          },
          child: Row(
            children: <Widget>[
              Tooltip(
                message: imagesList[index].name,
                child: ImageSquare(
                  //This width is set to make the image less wide than 1/5 of the screen.
                  width: MediaQuery.of(context).size.width/6,
                  key: Key('timetableImage$index'),
                  image: imagesList[index],
                ),
              ),
              //this is to prevent showing an arrow after the last image.
              if (index != imagesList.length - 1)
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