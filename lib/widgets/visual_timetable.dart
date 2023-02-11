import 'package:flutter/material.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';
import 'package:seg_coursework_app/widgets/timetable_block.dart';



class TimetableList extends StatelessWidget {
  const TimetableList({super.key, required this.imagesURL, required this.popImagesList});

  final List imagesURL;
  final Function popImagesList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imagesURL.length,
      itemBuilder: (context, index) {
        //ADD ON TAP HERE
        return GestureDetector(
          onTap: () {
            popImagesList(index);
          },
          child: Row(
            children: <Widget>[
              ImageSquare(imageURL: imagesURL[index], height: 150, width: 150,),
              if (index != imagesURL.length - 1)
                Icon(Icons.arrow_right),
            ],
          ),
        );
      },
    );
  }
}

class VisualTimetable extends StatefulWidget {
  VisualTimetable({super.key});

  @override
  State<VisualTimetable> createState() => _VisualTimetableState();
}

class _VisualTimetableState extends State<VisualTimetable> {
  List imagesURL = [
    "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg",
    "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80",
    "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg",
    "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325",
    "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}