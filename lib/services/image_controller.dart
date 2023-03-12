import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:seg_coursework_app/services/storage_service.dart';

class ImageController {
  final allImages = <Widget>[];
  final StorageService storageService = StorageService();

  ImageController() {}

  Future getAllImages() async {
    List<String> imgName = [
      "Basketball1678025412644",
      "Lunch??1678531022290",
      "Lunner1678542806330"
    ];
    try {
      for (String img in imgName) {
        //print("image = $img");
        final imgUrl =
            await storageService.getImage(img); //gets image path from Firebase
        //print("adding $imgUrl to list");
        allImages.add(Image.network(imgUrl!));
      }
      //print("list in controller class = $allImages");
    } catch (e) {
      print(e.toString());
    }
    return allImages;
  }
}
