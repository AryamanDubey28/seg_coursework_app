import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seg_coursework_app/models/list_of_lists_of_image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';

import '../models/image_details.dart';
import '../widgets/timetable_row.dart';

class AllSavedTimetables extends StatefulWidget {
  const AllSavedTimetables({super.key, required this.listOfTimetables});
  final ListOfListsOfImageDetails listOfTimetables;

  @override
  State<AllSavedTimetables> createState() => _AllSavedTimetablesState();
}

class _AllSavedTimetablesState extends State<AllSavedTimetables> {
  void unsaveList(List<ImageDetails> list)
  {
    setState(() {
      widget.listOfTimetables.remove(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Saved Timetables'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.listOfTimetables.length(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 5,),
              TimetableRow(
                listOfImages: widget.listOfTimetables[index],
                unsaveList: unsaveList,
              ),
            ],
          );
        },
      ),
    );
  }
}

