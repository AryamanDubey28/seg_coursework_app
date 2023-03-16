
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'package:seg_coursework_app/models/timetable.dart';

import '../models/image_details.dart';

final List<ImageDetails> testItems = [
  ImageDetails(
    name: "Toast", 
    imageUrl: "Toast.jpg", 
    itemId: "1"
  ),
  ImageDetails(
    name: "Orange", 
    imageUrl: "Orange.jpg", 
    itemId: "2"
  ),
  ImageDetails(
    name: "Footy", 
    imageUrl: "Footy.jpg", 
    itemId: "3"
  ),
  ImageDetails(
    name: "Boxing", 
    imageUrl: "Boxing.jpg", 
    itemId: "4"
  ),
  ImageDetails(
    name: "Swimming", 
    imageUrl: "Swimming.jpg", 
    itemId: "5"
  ),
];

final testTimetable = Timetable(title: "Test Timetable", listOfImages: testItems, workflowId: "1");

final testListOfTimetables = ListOfTimetables(listOfLists: [testTimetable]);