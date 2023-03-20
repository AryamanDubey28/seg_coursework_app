import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/helpers/cache_manager.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/services/loadingMixin.dart';
import 'package:seg_coursework_app/widgets/timetable/save_timetable_dialog.dart';
import '../../helpers/firebase_functions.dart';
import '../../helpers/snackbar_manager.dart';
import '../../models/image_details.dart';
import '../../widgets/loading_indicators/custom_loading_indicator.dart';
import '../../widgets/timetable/timetable_list.dart';
import '../admin/admin_side_menu.dart';
import '../../widgets/timetable/picture_grid.dart';
import 'all_saved_timetables.dart';

class VisualTimeTable extends StatefulWidget {
  VisualTimeTable({super.key,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage,
      this.isMock = false}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  final bool isMock;

  @override
  State<VisualTimeTable> createState() => _VisualTimeTableState();
}

/// The page for the admin to show the choice boards and make a timetable from that
class _VisualTimeTableState extends State<VisualTimeTable> with LoadingMixin<VisualTimeTable> {


  late FirebaseFunctions firestoreFunctions;

  bool isGridVisible = true;
  //The images that will be fed into the timetable. (No pictures are chosen by default.)
  List<ImageDetails> imagesList = [];

  //The images that will be fed into the PictureGrid (the choice board.)
  List<ImageDetails> filledImagesList = [];
  
  @override
  void initState() {
    super.initState();
    firestoreFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage
        );

  }

  @override
  void dispose() {
    if(!widget.isMock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  Future<void> load() async {
    await _fetchData();
  }

  ///Fetches data.
  Future<void> _fetchData() async
  { 
    await Future.wait([
      _fetchLibrary(),
    ]);

    setState(() {});
  }

  ///Fetches items from database if theres connection, from cache otherwise.
  Future<void> _fetchLibrary() async
  {
    if(!widget.isMock)
    {
      if(CheckConnection.isDeviceConnected)
      {
        try
        {
          filledImagesList = await firestoreFunctions.getUserItems();
          await CacheManager.storeUserItemsInCache(userItems: filledImagesList);
        }
        catch(e)
        {
          SnackBarManager.showSnackBarMessage(context, "Error loading saved items. Check connection.");
        }
      }
      else
      {
        filledImagesList = await CacheManager.getUserItemsFromCache();
        SnackBarManager.showSnackBarMessage(context, "No connection. Loading local data.");
      }
    }
    else
    {
      filledImagesList = await firestoreFunctions.getUserItems();
    }
    
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
      heroTag: "hideShowButton1",
      key: const Key("hideShowButton"),
      onPressed: _toggleGrid,
      tooltip: 'Show/Hide',
      child: Icon(
        isGridVisible ? Icons.hide_image_outlined : Icons.image,
      ),
    );
  }

  ///This function returns a button that shows the dialog to save the timetable to the database.
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
        if(!widget.isMock)
        {
          CheckConnection.isDeviceConnected?
          showDialog(
            context: context,
            builder: (_) => SaveTimetableDialog(imagesList: imagesList, 
            saveTimetable: firestoreFunctions.saveWorkflowToFirestore,
            isMock: widget.isMock,
            ),
          )
          : SnackBarManager.showSnackBarMessage(context, "Cannot save timetable. No connection.");
        }
        else
        {
          
          showDialog(
            context: context,
            builder: (_) => SaveTimetableDialog(imagesList: imagesList, 
            saveTimetable: firestoreFunctions.saveWorkflowToFirestore,
            isMock: widget.isMock,
            ),
          );
        }
      },
    );
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
          key: const Key ('app_bar'),
          title: const Text ('Loading items'),
        ),
        drawer: const AdminSideMenu(), 
        body: const CustomLoadingIndicator(),
      ); 
    } 
    else if (hasError) {
      return AlertDialog(
        content: const Text ('An error occurred while communicating with the database'), 
        actions: <Widget>[
          TextButton(
            child: const Text('Retry'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
              MaterialPageRoute (builder: (context) =>  VisualTimeTable()));
            }
          ),
        ]
      ); 
    } 
    else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isLandscapeMode = constraints.maxWidth > constraints.maxHeight;

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
                        builder: (context) => AllSavedTimetables(firestoreFunctions: firestoreFunctions, isMock: widget.isMock,),
                      ),
                    );
                  }, 
                icon: const Icon(Icons.list)
                ),
              ],
            ),
            drawer: const AdminSideMenu(),
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SizedBox(
                      //width here is set depending on the screen size. 6/6 represents the whole screen
                      // 5/6 allows it to be centered and have a bit of padding on the left and right side.
                      // 35 is an arbitrary number and represents the arrow size set in timetable_list. 4 is the number of arrows.
                      //In short: this sets the width to (5 * the width of each image) + (4 * the width of each arrow)
                      width: (constraints.maxWidth * (5/6) + (constraints.maxWidth/35*4)),
                      height: isLandscapeMode? constraints.maxHeight/4 : constraints.maxHeight/6.4,
                      child: timetableList,
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
          );
        }
      );
    }
  }
}