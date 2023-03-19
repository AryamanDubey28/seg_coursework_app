import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/list_of_lists_of_image_details.dart';
import '../../../widgets/admin_timetable/timetable_row.dart';

class AllSavedTimetables extends StatefulWidget {
  const AllSavedTimetables({super.key, required this.savedTimetables});
  final ListOfListsOfImageDetails savedTimetables;

  @override
  State<AllSavedTimetables> createState() => _AllSavedTimetablesState();
}

/// The page for the admin to see all the saved timetables and be able to delete unwanted ones.
class _AllSavedTimetablesState extends State<AllSavedTimetables> {
  ///This function is fed into the TimetableRow and will unsave the timetable from the list of saved timetables.
  void unsaveList(int index) {
    setState(() {
      widget.savedTimetables.removeAt(index);
    });
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
              const SizedBox(
                height: 5,
              ),
              TimetableRow(
                key: Key("timetableRow$index"),
                listOfImages: widget.savedTimetables[index],
                unsaveList: unsaveList,
                index: index,
              ),
            ],
          );
        },
      ),
    );
  }
}
