import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/list_of_lists_of_image_details.dart';

import '../models/image_details.dart';
import '../widgets/picture_grid.dart';
import '../widgets/timetable_list.dart';
import 'admin_side_menu.dart';
import 'all_saved_timetables.dart';

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
    ImageDetails(name: "Fish and chips", imageUrl: "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg"),
  ];
  ListOfListsOfImageDetails listOfTimetables = ListOfListsOfImageDetails(listOfLists: []);
  // List<List<ImageDetails>> listOfTimetables = [];

  List<ImageDetails> deepCopy(List<ImageDetails> list) {
  List<ImageDetails> copy = [];
  for (ImageDetails image in list) {
    copy.add(
      ImageDetails(
      name: image.name,
      imageUrl: image.imageUrl
      )
    );
  }
  return copy;
}

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
      heroTag: "hideShowButton",
      key: const Key("hideShowButton"),
      backgroundColor: isGridVisible ? Colors.teal : Colors.white,
      onPressed: _toggleGrid,
      tooltip: 'Show/Hide',
      child: Icon(
        isGridVisible ? Icons.hide_image_outlined : Icons.image,
        color: isGridVisible ? Colors.white : Colors.teal, 
        ),
    );
  }

  FloatingActionButton buildAddButton(TimetableList timetableList)
  {
    FloatingActionButton temp = FloatingActionButton(
      heroTag: "addToListOfListsButton",
      key: const Key("addToListOfListsButton"),
      backgroundColor: Colors.white,
      tooltip: 'Save List',
      child: const Icon(
        Icons.add,
        color: Colors.teal,),
      onPressed: () => addTimetableToListOfLists(timetableList.getImagesList()),
      
    );
    return temp;
  }

  void addTimetableToListOfLists(List<ImageDetails> imagesList) {
    setState(() {
      bool isAdded = listOfTimetables.addList(deepCopy(imagesList));
      showSnackBarMessage(isAdded);
    });
  }

  void showSnackBarMessage(bool isAdded) {
  if(isAdded)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Timetable added successfully.")
        ),
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Timetable is already stored.")
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TimetableList timetableList = TimetableList(
      key: const Key("timetableList"),
      imagesList: imagesList,
      popImagesList: popImagesList
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text("Visual Timetable"),
        actions: <Widget> [
          IconButton(
            key: const Key("allTimetablesButton"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllSavedTimetables(listOfTimetables: listOfTimetables),
                ),
              );
            }, 
          icon: const Icon(Icons.list)
          ),
        ],
      ),
      drawer: const AdminSideMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              width: 1100,
              height: 200,
              alignment: Alignment.center,
              child: timetableList,
            )
          ),
          // if (timetableList.imagesList.length >= 2) buildAddButton(timetableList),
          isGridVisible ? Divider(height: isGridVisible ? 50 : 0, thickness: 1, color: Colors.white,) : const SizedBox(),
          Expanded(
            flex: isGridVisible ? 5 : 0,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            if (timetableList.imagesList.length >= 2) Align(
              alignment: Alignment.bottomLeft,
              child: buildAddButton(timetableList),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: buildFloatingActionButton(),
            ),
          ],
        ),
      ),
    );
  }
  
  
}