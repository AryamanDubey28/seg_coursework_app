import 'image_details.dart';

class Timetable {
  List<ImageDetails> listOfImages;

  Timetable({required this.listOfImages});

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

  ImageDetails removeAt(int index)
  {
    return listOfImages.removeAt(index);
  }
}