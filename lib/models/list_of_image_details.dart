import 'image_details.dart';

class ListOfImageDetails {
  List<ImageDetails> listOfImages;

  ListOfImageDetails({required this.listOfImages});

  List<ImageDetails> getList()
  {
    return listOfImages;
  }
}