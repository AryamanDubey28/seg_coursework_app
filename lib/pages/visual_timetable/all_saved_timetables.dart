import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'package:seg_coursework_app/pages/visual_timetable/add_timetable.dart';
import 'package:seg_coursework_app/services/check_connection.dart';
import '../../helpers/snackbar_manager.dart';
import '../../models/timetable.dart';
import '../../widgets/timetable_list_dialog.dart';
import '../../widgets/timetable_row.dart';

class AllSavedTimetables extends StatefulWidget {
  const AllSavedTimetables({super.key, required this.savedTimetables});
  final ListOfTimetables savedTimetables;

  @override
  State<AllSavedTimetables> createState() => _AllSavedTimetablesState();
}

/// The page for the admin to see all the saved timetables and be able to delete unwanted ones.
class _AllSavedTimetablesState extends State<AllSavedTimetables> {

  @override
  void dispose() {
    CheckConnection.startMonitoring();
    super.dispose();
  }


  void expandTimetable(Timetable test)
  {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: TimetableListDialog(timetable: test),
        );
      }
    );
  }


  ///This function is fed into the TimetableRow and will unsave the timetable from the list of saved timetables.
  void unsaveList(int index) async
  {
    if(CheckConnection.isDeviceConnected)
    {
      await deleteWorkflowFromFirestore(timetable: widget.savedTimetables[index]);
      setState(() {
        widget.savedTimetables.removeAt(index);
      });
      SnackBarManager.showSnackBarMessage(context, "Timetable removed successfully");
    }
    else
    {
      SnackBarManager.showSnackBarMessage(context, "Cannot remove timetable. No connection.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Saved Timetables'),
        leading: IconButton(
          key: const Key("backButton"),
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.savedTimetables.length(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,15,0,15),
                child: TimetableRow(
                  key: Key("timetableRow$index"),
                  listOfImages: widget.savedTimetables[index],
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

