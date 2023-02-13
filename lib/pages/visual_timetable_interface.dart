import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/visual_timetable.dart';

class VisualTimetableInterface extends StatelessWidget {
  const VisualTimetableInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Timetable Interface',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[100],
      ),
      home: const VisualTimeTable(),
    );
  }
}