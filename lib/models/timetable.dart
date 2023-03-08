import 'image_details.dart';

class Timetable {
  String title;
  List<ImageDetails> listOfImages;
  late String workflowId;

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
}