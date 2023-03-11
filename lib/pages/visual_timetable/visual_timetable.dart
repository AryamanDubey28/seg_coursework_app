import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'package:seg_coursework_app/models/timetable.dart';
import 'package:seg_coursework_app/pages/visual_timetable/add_timetable.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/services/loadingMixin.dart';
import 'package:seg_coursework_app/widgets/save_timetable_dialog.dart';
import '../../helpers/snackbar_manager.dart';
import '../../models/image_details.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/loading_indicator.dart';
import '../admin/admin_side_menu.dart';
import '../../widgets/picture_grid.dart';
import '../../widgets/timetable_list.dart';
import 'all_saved_timetables.dart';

class VisualTimeTable extends StatefulWidget {
  const VisualTimeTable({super.key});

  @override
  State<VisualTimeTable> createState() => _VisualTimeTableState();
}

/// The page for the admin to show the choice boards and make a timetable from that
class _VisualTimeTableState extends State<VisualTimeTable> with LoadingMixin<VisualTimeTable> {//with WidgetsBindingObserver {
  // bool _isPictureGridLoaded = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    // LoadingIndicatorDialog().show(context);
    // _fetchData();
    // LoadingIndicatorDialog().dismiss();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    CheckConnection.stopMonitoring();
    super.dispose();
  }

  @override
  Future<void> load() async {
    await _fetchData();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed && _isPictureGridLoaded) {
  //     setState(() {});
  //   }
  // }

  Future<void> _fetchData() async
  { 
    await Future.wait([
      _fetchLibrary(),
      _fetchTimetables(),
    ]);

    setState(() {
    //   _isPictureGridLoaded = true;
    });
  }

  bool isGridVisible = true;
  //The images that will be fed into the timetable. (No pictures are chosen by default.)
  List<ImageDetails> imagesList = [];

  //The images that will be fed into the PictureGrid (the choice board.)
  List<ImageDetails> filledImagesList = [];

  //The list that holds the saved timetables
  ListOfTimetables savedTimetables = ListOfTimetables(listOfLists: []);

  Future<void> _fetchTimetables() async
  {
    savedTimetables = await fetchWorkflow();
  }
  Future<void> _fetchLibrary() async
  {
    // LoadingIndicatorDialog().show(context);
    filledImagesList = await fetchLibrary();
    // LoadingIndicatorDialog().dismiss();
  }
   //


  ///This makes a deep copy of a list to be saved in the savedTimetables 
  Timetable deepCopy(String title, List<ImageDetails> list) {
  Timetable copy = Timetable(title: title, listOfImages: []);
  // for (ImageDetails image in list) {
  for (int i = 0 ; i < list.length; i++){
    copy.add(
      ImageDetails(
      name: list[i].name,
      imageUrl: list[i].imageUrl,
      itemId: list[i].itemId,
      )
    );
  }
  return copy;
}

  ///This function is supplied to the PictureGrid and it adds the chosen image to the Timetable builder
  ///and hides the PictureGrid when 5 images are chosen for the Timetable
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

  ///This function is supplied to the Timetable and it removes the chosen image from the Timetable builder
  ///and shows the PictureGrid when less than 5 images are chosen for the Timetable
  void popImagesList(int index) {
    setState(() {
      imagesList.removeAt(index);
      if (imagesList.length < 5) {
        isGridVisible = true;
      }
    });
  }

  ///This function hides/shows the grid when the hide/show FloatingActionButton is pressed.
  void _toggleGrid() {
    setState(() {
      isGridVisible = !isGridVisible;
    });
  }

  ///This function returns a hide/show button (for the PictureGrid.)
  FloatingActionButton buildHideButton() {
    return FloatingActionButton(
      heroTag: "hideShowButton",
      key: const Key("hideShowButton"),
      onPressed: _toggleGrid,
      tooltip: 'Show/Hide',
      child: Icon(
        isGridVisible ? Icons.hide_image_outlined : Icons.image,
      ),
    );
  }

  ///This function returns a button that saves the timetable to a list of timetables.
  FloatingActionButton buildAddButton(List<ImageDetails> imagesList)
  {
    return FloatingActionButton(
      heroTag: "addToListOfListsButton",
      key: const Key("addToListOfListsButton"),
      tooltip: 'Save List',
      child: const Icon(
        Icons.add,
      ),
      onPressed: () {
        CheckConnection.isDeviceConnected?
        showDialog(
          context: context,
          builder: (_) => SaveTimetableDialog(imagesList: imagesList, addTimetableToListOfLists: addTimetableToListOfLists,),
        )
        : SnackBarManager.showSnackBarMessage(context, "Cannot save timetable. No connection.");
      },
    );
  }

  ///This function saves a timetable into the list of timetables.
  void addTimetableToListOfLists(String title, List<ImageDetails> imagesList) async {
    Timetable temp = deepCopy(title, imagesList);
    if (!savedTimetables.existsIn(temp))
    {
      await savedTimetables.saveWorkflowToDatabase(temp);
      setState(() {
      savedTimetables.addList(temp);
      });
      SnackBarManager.showSnackBarMessage(context, "Timetable saved successfully.");
    }
    else
    {
      SnackBarManager.showSnackBarMessage(context, "Timetable is already saved.");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    TimetableList timetableList = TimetableList(
      key: const Key("timetableList"),
      imagesList: imagesList,
      popImagesList: popImagesList
    );

    if(loading) {
      return Scaffold(
        appBar: AppBar(
          key: Key ('app_bar'),
          title: const Text ('Loading Choice Boards'),
        ),
        drawer: const AdminSideMenu(), 
        body: CustomLoadingIndicator(),
      ); 
    } 
    else if (hasError) {
      return AlertDialog(
        content: Text ('An error occurred while communicating with the database'), 
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
              MaterialPageRoute (builder: (context) =>  VisualTimeTable()));
            }
          ),
        ]
      ); 
    } 
    else {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: const Text("Visual Timetable"),
          actions: <Widget> [
            IconButton(
              key: const Key("allTimetablesButton"),
              tooltip: "View all saved timetables",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllSavedTimetables(savedTimetables: savedTimetables),
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
              flex: 4,
              child: Center(
                child: Container(
                  //width here is set depending on the screen size. 6/6 represents the whole screen
                  // 5/6 allows it to be centered and have a bit of padding on the left and right side.
                  // 35 is an arbitrary number and represents the arrow size set in timetable_list. 4 is the number of arrows.
                  //In short: this sets the width to (5 * the width of each image) + (4 * the width of each arrow)
                  width: (MediaQuery.of(context).size.width * (5/6) + (MediaQuery.of(context).size.width/35*4)),
                  height: 200,
                  alignment: Alignment.center,
                  child: Align(alignment: Alignment.center ,child: timetableList),
                ),
              )
            ),
            isGridVisible ? Divider(height: isGridVisible ? 50 : 0, thickness: 0, color: Colors.white,) : const SizedBox(),
            Expanded(
              //This will make the timetable bigger if the PictureGrid is not visible
              flex: isGridVisible ? 8 : 0,
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

        //This is to add two floatingActionButtons and allign them to the corners of the screen.
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: <Widget>[
              //This makes sure that a timetable can't be saved if it has one or no elements.
              if (imagesList.length >= 2) Align(
                alignment: Alignment.bottomLeft,
                child: buildAddButton(imagesList),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: buildHideButton(),
              ),
            ],
          ),
        ),
      );
    }
  }
  
  
}