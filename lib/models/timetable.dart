import 'image_details.dart';

class Timetable {
  String title;
  List<ImageDetails> listOfImages;
  String workflowId;

  Timetable({this.title = "Timetable Title", required this.listOfImages, this.workflowId = ""});

  int length()
  {
    return listOfImages.length;
  }

  ImageDetails get(int index)
  {
    return listOfImages[index];
  }

  void add(ImageDetails img)
  {
    listOfImages.add(img);
  }

  void insert(int index, ImageDetails img)
  {
    listOfImages.insert(index, img);
  }

  ImageDetails removeAt(int index)
  {
    return listOfImages.removeAt(index);
  }

  void setID({required String id}) {
    workflowId = id;
  }

  factory Timetable.fromJson(Map<String, dynamic> json) {
    final list = json['listOfImages'] as List<dynamic>;
    final listOfImages = list
        .map((item) => ImageDetails.fromJson(item as Map<String, dynamic>))
        .toList();
    return Timetable(
        title: json['title'] as String,
        listOfImages: listOfImages,
        workflowId: json['workflowId'] as String);
  }

  Map<String, dynamic> toJson() {
    final jsonListOfImages =
        listOfImages.map((item) => item.toJson()).toList();
    return {
      'title': title,
      'listOfImages': jsonListOfImages,
      'workflowId': workflowId,
    };
  }
}