import 'package:flutter/material.dart';
import '../../models/timetable.dart';
import '../general/image_square.dart';

///This widget builds a timetable but without the arrows to be shown in the all saved timetables page.
///Not to be confused with TimetableList which is shown in the main visual timetable page.
class TimetableRow extends StatelessWidget {
  const TimetableRow({
  Key? key,
  required this.listOfImages,
  required this.unsaveList,
  required this.index, 
  required this.expandTimetable,
}) : super(key: key);

  final Timetable listOfImages;
  final Function unsaveList;
  final int index;
  final Function expandTimetable;

  ///This returns a delete button to unsave a list from the list of saved timetables.
  IconButton buildDeleteButton()
  {
    return IconButton(
      key: Key("deleteButton$index"),
      onPressed: (){

        unsaveList(index);
      }, 
      icon: const Icon(
        Icons.delete, 
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,15),
          child: Text(listOfImages.title),
        ),

        SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    expandTimetable(listOfImages);
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listOfImages.length(),
                    itemBuilder: (context, subIndex) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5,0,0,0),
                        child: Tooltip(
                          message: listOfImages[subIndex].name,
                          child: ImageSquare(
                            key: Key('timetableImage$subIndex'),
                            image: listOfImages[subIndex], 
                            //The width here is set to make sure the row isn't bigger than the screen and to make sure
                            //there is room for the delete button.
                            width: MediaQuery.of(context).size.width/6,
                          ),
                        ),
                      );
                    },  
                  ),
                ),
              ),
              buildDeleteButton(),
              const SizedBox(width: 15,)
            ],
          ),
        ),
      ],
    );
  }
}