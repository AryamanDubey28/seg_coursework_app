import 'package:flutter/material.dart';

import '../models/image_details.dart';
import '../widgets/picture_grid.dart';
import '../widgets/timetable_list.dart';

class VisualTimeTable extends StatefulWidget {
  const VisualTimeTable({super.key});

  @override
  State<VisualTimeTable> createState() => _VisualTimeTableState();
}

class _VisualTimeTableState extends State<VisualTimeTable> {

  bool isGridVisible = true;
  List<ImageDetails> imagesList = [];
  List<ImageDetails> filledImagesList = [
    ImageDetails(name: "Toast", imageUrl: "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
    ImageDetails(name: "Orange", imageUrl: "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"),
    ImageDetails(name: "Footy", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"),
    ImageDetails(name: "Boxing", imageUrl: "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"),
    ImageDetails(name: "Swimming", imageUrl: "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg"),
    ImageDetails(name: "Burger", imageUrl: "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg"),
  ];


  void updateImagesList(ImageDetails image) {
    setState(() {
      if (imagesList.length < 5) {
        imagesList.add(image);
      }
      if (imagesList.length >= 5)
      {
        isGridVisible = false;
      }
    });
  }

  void popImagesList(int index) {
    setState(() {
      imagesList.removeAt(index);
      if (imagesList.length < 5) {
        isGridVisible = true;
      }
    });
  }

  void _toggleGrid() {
    setState(() {
      isGridVisible = !isGridVisible;
    });
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: isGridVisible ? Colors.teal : Colors.white,
      onPressed: _toggleGrid,
      tooltip: 'Show/Hide',
      child: Icon(
        isGridVisible ? Icons.hide_image_outlined : Icons.image,
        color: isGridVisible ? Colors.white : Colors.teal, 
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visual Timetable"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: 1100,
              height: 200,
              alignment: Alignment.center,
              child: TimetableList(
                imagesList: imagesList,
                popImagesList: popImagesList
              ),
            )
          ),
          const Divider(height: 50, thickness: 1),
          Expanded(
            flex: 5,
            child: Visibility(
              visible: isGridVisible,
              child: PictureGrid(
                imagesList: filledImagesList, 
                updateImagesList: updateImagesList
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}