import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/timetable.dart';

/// Tests for the "list_of_timetables.dart" model.
void main() {
  late ListOfTimetables userListOfTimetables;
  late Map<String, dynamic> userListOfTimetablesJson;

  /// Creates an list_of_timetables object dataset to test with
  ListOfTimetables _createTestListOfTimetables() {
    return ListOfTimetables(
      listOfLists: [
        Timetable(
          title: "Test Timetable",
          listOfImages: [
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
          ],
          workflowId: "1"
        ),
      ]
    );
  }

  /// Create an list_of_timetables object in json data format to test
  Map<String, dynamic> _createTestListOfTimetablesJsonData() {
    return {
      'listOfLists': 
      [{
        'title': 'Test Timetable',
        'listOfImages': [
          {'name': 'Toast', 'imageUrl': 'Toast.jpg' , 'itemId': '1'}, 
          {'name': 'Orange', 'imageUrl': 'Orange.jpg', 'itemId': '2'}
        ],
        'workflowId': '1'
      }]
    };
  }

  setUp(() {
    userListOfTimetables = _createTestListOfTimetables();
    userListOfTimetablesJson = _createTestListOfTimetablesJsonData();
  });

  test("toJson converts a ListOfTimetables to json data successfully", () {
    expect(userListOfTimetables.toJson(), userListOfTimetablesJson);
  });
  test("fromJson converts json data to an ListOfTimetables object successfully", () {
    ListOfTimetables objectFromJson = ListOfTimetables.fromJson(userListOfTimetablesJson);
    expect(objectFromJson.equals(userListOfTimetables), true);
  });
}
