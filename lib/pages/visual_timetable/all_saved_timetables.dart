import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import 'package:seg_coursework_app/services/loadingMixin.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';
import '../../helpers/firebase_functions.dart';
import '../../helpers/snackbar_manager.dart';
import '../../models/timetable.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/timetable_list_dialog.dart';
import '../../widgets/timetable_row.dart';

class AllSavedTimetables extends StatefulWidget {
  final FirebaseFunctions firestoreFunctions;
  final bool isMock;

  const AllSavedTimetables({super.key, required this.firestoreFunctions, this.isMock = false});

  @override
  State<AllSavedTimetables> createState() => _AllSavedTimetablesState();
}

/// The page for the admin to see all the saved timetables and be able to delete unwanted ones.
class _AllSavedTimetablesState extends State<AllSavedTimetables> with LoadingMixin<AllSavedTimetables>{

  ListOfTimetables savedTimetables = ListOfTimetables(listOfLists: []);

  @override
  void dispose() {
    if (!widget.isMock) {
      CheckConnection.stopMonitoring();
    }
    super.dispose();
  }

  @override
  Future<void> load() async {
    await _fetchData();
  }

  ///Fetches data from database if theres connection, fetches data from cache otherwise TO BE DONE.
  Future<void> _fetchData() async
  { 
    await Future.wait([
      _fetchTimetables(),
    ]);

    setState(() {});
  }

  ///Fetches timetables from database.
  Future<void> _fetchTimetables() async
  {
    try 
    {
      savedTimetables = await widget.firestoreFunctions.getListOfTimetables();
    } 
    catch(e) 
    {
      SnackBarManager.showSnackBarMessage(context, "Error loading saved timetables. Check connection.");
    }
  }

  ///Expands the timetable and shows it to the user.
  void expandTimetable(Timetable test)
  {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Center(
            child: TimetableListDialog(timetable: test)
            ),
        );
      }
    );
  }


  ///This function is fed into the TimetableRow and will unsave the timetable from the database.
  void unsaveList(int index) async
  {
    if(!widget.isMock && !CheckConnection.isDeviceConnected)
    {
      SnackBarManager.showSnackBarMessage(context, "Cannot remove timetable. No connection.");
      return;
    }

    if(!widget.isMock) {
      LoadingIndicatorDialog().show(context, text: "Deleting timetable...");
    }
    await widget.firestoreFunctions.deleteWorkflow(timetable: savedTimetables[index]);
    
    if(!widget.isMock) {
      LoadingIndicatorDialog().dismiss();
    }
    setState(() {
      savedTimetables.removeAt(index);
    });
    SnackBarManager.showSnackBarMessage(context, "Timetable removed successfully");
    
  }

  IconButton buildBackButton(BuildContext context) {
    return IconButton(
          key: const Key("backButton"),
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        );
  }


  @override
  Widget build(BuildContext context) {
    if(loading)
    {
      return Scaffold(
        appBar: AppBar(
          key: Key ('app_bar'),
          title: const Text ('Loading timetables'),
          leading: buildBackButton(context),
        ),
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
              MaterialPageRoute (builder: (context) =>  AllSavedTimetables(firestoreFunctions: widget.firestoreFunctions,)));
            }
          ),
        ]
      ); 
    } 
    else
    {
      return Scaffold(
        appBar: AppBar(
          title: const Text('All Saved Timetables'),
          leading: buildBackButton(context),
        ),
        body: savedTimetables.isEmpty() 
        ? 
        Center(child: Container(child: Text("No saved timetables. Save one in the 'Visual Timetable' page."),))
        :
        ListView.builder(
          itemCount: savedTimetables.length(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,15,0,15),
                  child: TimetableRow(
                    key: Key("timetableRow$index"),
                    listOfImages: savedTimetables[index],
                    unsaveList: unsaveList,
                    index: index,
                    expandTimetable: expandTimetable
                  ),
                ),
                Divider()
              ],
            );
          },
        ),
      );
    }
  }
}