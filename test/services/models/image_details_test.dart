import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/models/image_details.dart';

/// Tests for the "image_details.dart" model.
void main() {
  late ImageDetails userImageDetails;
  late Map<String, dynamic> userImageDetailsJson;

  /// Creates an image_details object dataset to test with
  ImageDetails _createTestImageDetails() {
    return ImageDetails(
      itemId: "1",
      name: "Toast",
      imageUrl: "Toast.jpg");
  }

  /// Create an image_details object in json data format to test
  Map<String, dynamic> _createTestImageDetailsJsonData() {
    return {
      'name': 'Toast',
      'imageUrl': 'Toast.jpg',
      'itemId': '1'
    };
  }

  setUp(() {
    userImageDetails = _createTestImageDetails();
    userImageDetailsJson = _createTestImageDetailsJsonData();
  });

  test("toJson converts a ImageDetails to json data successfully", () {
    expect(userImageDetails.toJson(), userImageDetailsJson);
  });
  test("fromJson converts json data to an ImageDetails object successfully", () {
    ImageDetails objectFromJson = ImageDetails.fromJson(userImageDetailsJson);
    expect(objectFromJson.equals(userImageDetails), true);
  });
}
