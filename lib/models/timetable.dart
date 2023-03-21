import 'image_details.dart';

///This model handles timetables to be easily saved and deleted. It's also used in the list of timetables to easily store saved timetables.
class Timetable {
  String title;
  List<ImageDetails> listOfImages;
  String workflowId;

  Timetable({this.title = "Timetable Title", required this.listOfImages, this.workflowId = ""});

  int length()
  {
    return listOfImages.length;
  }

  ImageDetails operator[](int index)
  {
    return listOfImages[index];
  }

  void setID({required String id}) {
    workflowId = id;
  }

  bool equals(Timetable other)
  {
    if (title != other.title || workflowId != other.workflowId || listOfImages.length != other.listOfImages.length) {
      return false;
    }
    //Check if all the ImageDetails object are equal.
    for(int i = 0 ; i < listOfImages.length ; i++)
    {
      if(!listOfImages[i].equals(other.listOfImages[i]))
      {
        return false;
      }
    }

    return true;
  }

  ///Converts a json map (from the cache) to an object.
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

  ///Converts an object to a json map (to be stored in the cache.)
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