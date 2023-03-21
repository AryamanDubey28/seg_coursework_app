import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/timetable.dart';

/// Tests for the "timetable.dart" model.
void main() {
  late Timetable userTimetable;
  late Map<String, dynamic> userTimetableJson;

  /// Creates an timetable object dataset to test with
  Timetable _createTestTimetable() {
    return Timetable(
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
    );
  }

  /// Create an timetable object in json data format to test
  Map<String, dynamic> _createTestTimetableJsonData() {
    return {
      'title': 'Test Timetable',
      'listOfImages': [
        {'name': 'Toast', 'imageUrl': 'Toast.jpg' , 'itemId': '1'}, 
        {'name': 'Orange', 'imageUrl': 'Orange.jpg', 'itemId': '2'}
      ],
      'workflowId': '1'
    };
  }

  setUp(() {
    userTimetable = _createTestTimetable();
    userTimetableJson = _createTestTimetableJsonData();
  });

  test("toJson converts a Timetable to json data successfully", () {
    expect(userTimetable.toJson(), userTimetableJson);
  });
  test("fromJson converts json data to an Timetable object successfully", () {
    Timetable objectFromJson = Timetable.fromJson(userTimetableJson);
    expect(objectFromJson.equals(userTimetable), true);
  });
}
